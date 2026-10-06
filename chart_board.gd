extends Control
## The corkboard behind the org chart: cork texture, and string between pinned cards.
## Each link is [card_a, card_b]. It's a faint dotted line until both cards are confirmed,
## then a taut red string. Cards (children) are drawn on top of the strings.

const CORK := Color(0.62, 0.46, 0.3)
const STRING_RED := Color(0.78, 0.08, 0.08)
const STRING_FAINT := Color(0.35, 0.22, 0.14, 0.7)

## [[Control, Control], ...]
var links: Array = []
## Control -> true when every box on that card is confirmed.
var solved_cards := {}

var _specks: PackedVector2Array
var _speck_sizes: PackedFloat32Array


func _ready() -> void:
	var rng := RandomNumberGenerator.new()
	rng.seed = 411
	for i in 1400:
		_specks.append(Vector2(rng.randf(), rng.randf()))
		_speck_sizes.append(rng.randf_range(0.6, 2.2))


func _draw() -> void:
	draw_rect(Rect2(Vector2.ZERO, size), CORK)
	for i in _specks.size():
		var shade := 0.75 + 0.3 * fmod(float(i) * 0.37, 1.0)
		draw_circle(_specks[i] * size, _speck_sizes[i], Color(CORK.r * shade, CORK.g * shade, CORK.b * shade))
	for link in links:
		var a: Control = link[0]
		var b: Control = link[1]
		var from := _pin_point(a)
		var to := _pin_point(b)
		if solved_cards.get(a, false) and solved_cards.get(b, false):
			draw_line(from + Vector2(1, 2), to + Vector2(1, 2), Color(0, 0, 0, 0.25), 3.0)  # shadow
			draw_line(from, to, STRING_RED, 2.5, true)
		else:
			draw_dashed_line(from, to, STRING_FAINT, 1.5, 6.0)


## Where the pin sits on a card: centred, just below its top edge.
func _pin_point(card: Control) -> Vector2:
	return card.position + Vector2(card.size.x * 0.5, 10.0)
