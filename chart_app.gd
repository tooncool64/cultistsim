extends VBoxContainer
## Chart: a corkboard "conspiracy wall" of Harrow Lane. Index cards grouped in sections (the
## church, the Upper Room, the Board of Ten, the Grange, who they took, who's on your side...),
## pinned up and joined by string. Strings go from faint dotted lines to taut red string as both
## cards they join are confirmed.
## Data: res://data/chart.json (sections, cards with boxes to fill, links between cards). The board
## fills the chart window's width; each section is a block of cards (chart.json "per_row" caps a
## row, e.g. the Board of Ten in two rows of five), and the blocks pack in shelves. Every
## clickable name and organization in the game has exactly one box, except the "reuse" cards (the
## Upper Room, the Seven), which name people already on the wall. Answers lock in Roottrees-style (3+ new
## correct answers at once).

## The board is as wide as the chart window (it only scrolls down); never narrower than this.
const MIN_BOARD_WIDTH := 900.0
const MARGIN := 18.0
## Between cards in a section, and between sections.
const GAP := Vector2(22, 34)
const SECTION_GAP := Vector2(36, 40)
## Room above a section's cards for its masking-tape title.
const TITLE_HEIGHT := 34.0
const PAPER := Color(0.97, 0.94, 0.84)
const INK := Color(0.14, 0.11, 0.09)
const PENCIL := Color(0.36, 0.2, 0.14)
const PIN := Color(0.8, 0.1, 0.1)
var desktop

var _options := {}   # slot id -> OptionButton
var _cards: Array[Control] = []
var _card_by_id := {}  # chart.json card id -> card
var _card_section := {}  # card -> section id
var _section_titles := {}  # section id -> Label
var _card_slots := {}  # card -> [slot ids]
var _layout_queued := false
var _stamps := {}      # card -> Label
var _board: Control
var _scroll: ScrollContainer
var _section_order: Array = []  # section ids, in chart.json order
var _section_per_row := {}  # section id -> most cards in one row (chart.json "per_row")
var _status: Label
var _clue_list: RichTextLabel
var _hand_font: SystemFont
var _type_font: SystemFont


func build() -> void:
	_hand_font = SystemFont.new()
	_hand_font.multichannel_signed_distance_field = true
	_hand_font.font_names = PackedStringArray(["Segoe Print", "Comic Sans MS", "sans-serif"])
	_type_font = SystemFont.new()
	_type_font.multichannel_signed_distance_field = true
	_type_font.font_names = PackedStringArray(["Courier New", "monospace"])
	_type_font.font_weight = 700

	var header := HBoxContainer.new()
	add_child(header)
	var intro := Label.new()
	intro.text = GameState.chart["intro"]
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	intro.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	header.add_child(intro)
	_status = Label.new()
	header.add_child(_status)
	header.add_child(desktop.make_button("Check chart", _check))

	var tabs := TabContainer.new()
	tabs.size_flags_vertical = Control.SIZE_EXPAND_FILL
	add_child(tabs)

	_scroll = ScrollContainer.new()
	_scroll.name = "Board"
	_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	_scroll.resized.connect(_queue_layout)  # wider window, wider board
	tabs.add_child(_scroll)
	_board = Control.new()
	_board.set_script(preload("res://scripts/apps/chart_board.gd"))
	_board.custom_minimum_size = Vector2(MIN_BOARD_WIDTH, 1200)
	_scroll.add_child(_board)
	_build_board()

	_clue_list = desktop.make_rich_text(Color(0.96, 0.95, 0.92))
	_clue_list.name = "Clues"
	tabs.add_child(_clue_list)

	var notes := TextEdit.new()
	notes.name = "Notes"
	notes.placeholder_text = "Your own notes..."
	notes.wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY
	notes.text = GameState.scratchpad
	notes.text_changed.connect(func(): GameState.scratchpad = notes.text)
	tabs.add_child(notes)

	refresh()


func refresh() -> void:
	for slot in GameState.chart_slots():
		_fill_options(_options[slot["id"]], slot)
	var solved_cards := {}
	for card in _cards:
		var solved := true
		for id in _card_slots[card]:
			solved = solved and GameState.chart_solved.has(id)
		solved_cards[card] = solved
		_stamps[card].visible = solved
	_board.solved_cards = solved_cards
	_board.queue_redraw()
	_status.text = "  %d / %d confirmed  " % [GameState.chart_solved.size(), GameState.chart_slots().size()]
	_clue_list.text = _clue_bbcode()


# --- Layout ----------------------------------------------------------------

func _build_board() -> void:
	var data: Dictionary = GameState.chart
	var rng := RandomNumberGenerator.new()
	rng.seed = 1977  # the same slightly messy board every time
	for section in data["sections"]:
		var title := _label(section["title"], _type_font, 15, INK)
		title.autowrap_mode = TextServer.AUTOWRAP_OFF
		var tape := StyleBoxFlat.new()
		tape.bg_color = Color(0.93, 0.88, 0.7, 0.9)  # masking tape
		tape.set_content_margin_all(5)
		tape.content_margin_left = 12
		tape.content_margin_right = 12
		title.add_theme_stylebox_override("normal", tape)
		title.rotation_degrees = rng.randf_range(-1.5, 1.5)
		_board.add_child(title)
		_section_titles[section["id"]] = title
		_section_order.append(section["id"])
		_section_per_row[section["id"]] = int(section.get("per_row", 0))
		for card_data in data["cards"]:
			if card_data["section"] != section["id"]:
				continue
			var slots := []
			for slot in card_data["slots"]:
				var text := String(slot.get("label", ""))
				if String(slot.get("hint", "")) != "":
					text = (text + " " + String(slot["hint"])).strip_edges()
				slots.append({"id": slot["id"], "category": slot["category"], "hint": text})
			var card := _add_card(card_data["heading"], card_data.get("note", ""), slots, Vector2.ZERO,
				float(card_data.get("width", 220)), rng)
			_card_by_id[card_data["id"]] = card
			_card_section[card] = section["id"]
	var links: Array = []
	for pair in data["links"]:
		links.append([_card_by_id[pair[0]], _card_by_id[pair[1]]])
	_board.links = links
	_queue_layout()


## Lays the board out again after the cards settle on their real sizes (their text wraps a frame
## or two after they're built, and again whenever a box's contents change).
func _queue_layout() -> void:
	if _layout_queued:
		return
	_layout_queued = true
	_layout.call_deferred()


## Lays each section out as a block (its tape title, then its cards in rows), then packs the
## blocks across the board in shelves, left to right, as wide as the window allows.
func _layout() -> void:
	_layout_queued = false
	var board_width := maxf(MIN_BOARD_WIDTH, _scroll.size.x - 12.0)  # leave the scrollbar its room
	var inner := board_width - MARGIN * 2.0
	var x := MARGIN
	var y := MARGIN
	var shelf_height := 0.0
	for section in _section_order:
		var cards: Array = _cards.filter(func(c): return _card_section[c] == section)
		if cards.is_empty():
			continue
		# The block: rows of cards, at most per_row to a row, never wider than the board.
		var per_row: int = _section_per_row[section]
		var spots: Array[Vector2] = []
		var cx := 0.0
		var cy := TITLE_HEIGHT
		var row_height := 0.0
		var in_row := 0
		var block := Vector2.ZERO
		for card in cards:
			var w: float = card.size.x
			if in_row > 0 and ((per_row > 0 and in_row >= per_row) or cx + w > inner):
				cx = 0.0
				cy += row_height + GAP.y
				row_height = 0.0
				in_row = 0
			spots.append(Vector2(cx, cy))
			block.x = maxf(block.x, cx + w)
			cx += w + GAP.x
			row_height = maxf(row_height, card.size.y)
			in_row += 1
		block.y = cy + row_height
		# The shelf: a block that doesn't fit beside the last one starts a new shelf.
		if x > MARGIN and x + block.x > board_width - MARGIN:
			x = MARGIN
			y += shelf_height + SECTION_GAP.y
			shelf_height = 0.0
		var title: Label = _section_titles[section]
		title.position = Vector2(x, y)
		for i in cards.size():
			cards[i].position = Vector2(x, y) + spots[i]
		x += block.x + SECTION_GAP.x
		shelf_height = maxf(shelf_height, block.y)
	_board.custom_minimum_size = Vector2(board_width, y + shelf_height + MARGIN * 2)
	_board.queue_redraw()


## An index card pinned to the board: a typed heading, handwritten notes, and boxes to fill.
func _add_card(heading: String, note: String, slots: Array, pos: Vector2, width: float,
		rng: RandomNumberGenerator) -> Control:
	var card := Control.new()
	card.position = pos
	card.rotation_degrees = rng.randf_range(-2.5, 2.5)
	_board.add_child(card)

	var paper := PanelContainer.new()
	paper.custom_minimum_size.x = width
	var style: StyleBoxFlat = desktop.box(PAPER, 10)
	style.content_margin_top = 18
	style.content_margin_bottom = 30  # room for the CONFIRMED stamp
	style.shadow_color = Color(0, 0, 0, 0.35)
	style.shadow_size = 4
	style.shadow_offset = Vector2(2, 3)
	paper.add_theme_stylebox_override("panel", style)
	card.add_child(paper)
	paper.resized.connect(_on_paper_resized.bind(card, paper))

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 3)
	paper.add_child(box)
	box.add_child(_label(heading, _type_font, 12, INK))
	box.add_child(_label(note, _hand_font, 13, PENCIL))
	var ids := []
	for slot in slots:
		if slot["hint"] != "":
			box.add_child(_label(slot["hint"], _hand_font, 11, PENCIL))
		var ob := OptionButton.new()
		ob.clip_text = true
		ob.item_selected.connect(_on_selected.bind(slot["id"], ob))
		box.add_child(ob)
		_options[slot["id"]] = ob
		ids.append(slot["id"])

	var pin := Panel.new()
	var pin_style := StyleBoxFlat.new()
	pin_style.bg_color = PIN
	pin_style.set_corner_radius_all(8)
	pin_style.shadow_color = Color(0, 0, 0, 0.4)
	pin_style.shadow_size = 2
	pin.add_theme_stylebox_override("panel", pin_style)
	pin.size = Vector2(16, 16)
	pin.position = Vector2(width * 0.5 - 8, 2)
	card.add_child(pin)

	var stamp := _label("CONFIRMED", _type_font, 17, Color(0.75, 0.1, 0.1, 0.8))
	stamp.autowrap_mode = TextServer.AUTOWRAP_OFF
	stamp.rotation_degrees = -8
	stamp.visible = false
	card.add_child(stamp)

	_cards.append(card)
	_card_slots[card] = ids
	_stamps[card] = stamp
	return card


func _on_paper_resized(card: Control, paper: Control) -> void:
	card.size = paper.size
	_queue_layout()
	card.pivot_offset = paper.size * 0.5  # tilt around the card's centre
	if _stamps.has(card):
		_stamps[card].position = Vector2(paper.size.x - 128, paper.size.y - 30)  # bottom-right corner
	_board.queue_redraw()


func _label(text: String, font: Font, font_size: int, color: Color) -> Label:
	var l := Label.new()
	l.text = text
	l.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	l.add_theme_font_override("font", font)
	l.add_theme_font_size_override("font_size", font_size)
	l.add_theme_color_override("font_color", color)
	return l


# --- Behaviour ---------------------------------------------------------------

func _fill_options(ob: OptionButton, slot: Dictionary) -> void:
	var id: String = slot["id"]
	var chosen: String = GameState.chart_answers.get(id, "")
	ob.clear()
	ob.add_item("?")
	var locked := {} if slot.get("reuse", false) else _locked_terms()
	for term in GameState.clues_in(slot["category"]):
		if locked.has(term) and term != chosen:
			continue  # already confirmed in another box
		ob.add_item(term)
		if term == chosen:
			ob.select(ob.item_count - 1)
	ob.disabled = GameState.chart_solved.has(id)
	ob.add_theme_color_override("font_disabled_color", Color(0.1, 0.42, 0.15))


## Names and companies already confirmed somewhere on the chart (not counting the Upper Room
## card, whose names also belong somewhere else).
func _locked_terms() -> Dictionary:
	var reused := {}
	for slot in GameState.chart_slots():
		if slot["reuse"]:
			reused[slot["id"]] = true
	var out := {}
	for id in GameState.chart_solved:
		var term: String = GameState.chart_answers.get(id, "")
		if term != "" and not reused.has(id):
			out[term] = true
	return out


func _on_selected(index: int, id: String, ob: OptionButton) -> void:
	GameState.chart_answers[id] = ob.get_item_text(index) if index > 0 else ""


func _check() -> void:
	var result := GameState.check_chart()
	if result["remaining"] == 0:
		desktop.toast("Every box filled. Check your mail.")
	elif result["confirmed"] > 0:
		desktop.toast("%d confirmed." % result["confirmed"])
	else:
		desktop.toast("Nothing confirmed: fewer than three new answers are right.")
	refresh()


func _clue_bbcode() -> String:
	if GameState.clues.is_empty():
		return "[color=#777777]Nothing yet. Click highlighted names in Seeker or Mail to collect them.[/color]"
	var t := ""
	for category in GameState.CATEGORY_NAMES:
		var terms := GameState.clues_in(category)
		if terms.is_empty():
			continue
		t += "[font_size=20][b]%s[/b][/font_size]\n" % GameState.CATEGORY_NAMES[category]
		for term in terms:
			t += "  - %s\n" % term
		t += "\n"
	return t
