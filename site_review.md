# sites.json review: images, lore expansion, prose

Reviewed all 176 pages against `lore.md` (2026-09-29).

## 1. Where pictures or GIFs would help

Right now only the Hamster Dance page uses a real image (`@image@` plus the `image` field). Many other
pages already have `[image: x.gif]` text stubs, so each one is an easy swap. They're listed below with
the story-bearing images first.

### Images that carry story (highest value)
| Page | Image | Why it earns its place |
|---|---|---|
| `evangelicalsintl.org/images/keepers_book_p01.jpg` and `_p02.jpg` | Water-stained brown-ink scans with the pencil notes by E.C. | The page claims to be a 1600x1200 scan. Showing the handwriting (C. Hale's page, then Wendell's shaky 1931 page) makes the game's central document feel real. Keep the transcription under it. |
| `bidhaus.com/item-2208131` | Photo of the brass lantern with its red glass | Every auction listing has a photo. This is the lamp the player has to protect on 10/31, so they should know what it looks like before then. |
| `home.millnet.com/~wgreaves` | Photo of the model layout from the top of the stairs: a point-down star, 8 lit brass lanterns, 2 empty platforms, 413's yard painted dark, and a little man in 411's window | The page announces "NEW PICS ADDED 10/03!" The picture shows the count-to-ten motif at a glance, and the player spots their own house in it. |
| `home.millnet.com/~bgunderson` | Photo of the "Ten Candles" quilt: gold on navy, point-down star, 8 gold candles and 2 blank | The same motif as the layout. `harvest-2004` could reuse the photo in its quilt-show item. |
| `home.millnet.com/~jfinch` | Photo of the circular curio cabinet with 10 shelves, 8 of them full | Completes the set of three that `~harmonic` tells the player to go and count. |
| `harrowlanehoa.org/cams` (or a logged-in `hoacam` view) | Green night-mode CCTV stills. CAM-04 shows **411's back window**, CAM-03 shows the red lamp by the shed, CAM-02 is black | Seeing your own window on their camera is a strong scare. The cams page already jokes about "stills of the red lamp". |
| `home.millnet.com/~epell/ruth` | A missing-person photo of Ruth (an old school or church photo, slightly low-res) | A face makes the page land. |
| `home.millnet.com/~prennick` / `log` | Photo of the brass Grange lamp with its red filter in the roll-off shed, and the printed seismometer trace from 10/14 (two spikes 40 s apart) | Paul says he "printed the trace for the club". The trace could also go on `millbrookastro.org` next to Bill's results. |
| `users.journalbox.com/priya_n` | A scanned graph-paper sketch or spectrogram: a 21 Hz band, with the voice band vanishing under red | Presents her data set as evidence. |
| `flashpit.com/portal-24130` | **Animated GIF** of the Flash movie: the robot HOA lady, the tow-truck dragon, and (at the end, rarely) every house light going out except two | A reviewer describes an ending Tyler didn't animate. A GIF that sometimes shows that ending is an ideal use of animation. |
| `millbrookledger.com/archive/1931-lamps` and `1974-grange` | A grey microfilm crop of the headline, or a period photo | Makes the "transcribed from microfilm" framing concrete. |
| `millbrookcounty.gov/gis/harrow` | A crude utility-layer map of the 400 block, with the connector line drawn in and the drain at 411 flagged | Players can look at the star layout on a map instead of piecing it together. |
| `evangelicalsintl.org/old/suburbia` | Clip-art slide for Slide 9, "RED LIGHT (NEW for 2004!)" | A PowerPoint 2000 look is period-perfect and shows the propaganda the way the church presents it. |
| `quizbox.com/quiz-88213` | `pbpie.gif`, which is already referenced in an `<img>` tag | A literal missing asset. |

### Period texture (cheap wins; the stubs already exist)
- `evangelicalsintl.org` and `/judgement`: `dove_animated.gif`, `flames_divider.gif`, `banner_judgement04.gif`, and hit-counter digits (all of them are in `/images`).
- `home.millnet.com/~tsteve`: `construction_guy.gif`. Keep "Pics of the Beast (scanner broken)" broken, because that's the joke.
- `members.webhaven.com/tribforce_fan`: `flaming_bible.gif`, `trumpet_angel.gif`.
- `members.webhaven.com/legolasluvr`: `sparkles.gif`, `legolas_blinkie.gif`.
- `harvestfellowship.net`: `flaming_wheat_logo.gif`.
- `mercerconstruction.com`: `excavator_clipart.gif`.
- `kmlb.com/morningzoo`: `zoo_animals_dancing.gif`. `kmlb.com` could also play `kmlb_jingle.mid` using the `music` field.
- `millbrookcarecenter.com`: `rocking_chair.gif`. `members.webhaven.com/mvole`: `scissors_animated.gif`.
- `home.spokanelink.net/~carolq`: `log_cabin_border.gif`. `millbrookhigh.k12.wa.us/alumni`: `miller_mascot.gif`.
- `clearskyclock.net/millbrook`: the real Clear Sky Clock is a colored block graphic, so an image would read better than the ASCII table.

### Leave these broken on purpose
The `[image not archived: ...]` lines on the WebTime pages, Abel's rims ("pics wont load tho"), Barb's
`kittens.jpg ... image not loading`, Joan's removed rental photos, and Clarence's "PHOTOS COMING SOON".
Each of these missing images is part of the joke or the story.

### Audio (not asked, but the `music` field exists)
`soundhaus.com/seismometer` track 4, "315 (field recording)", is the obvious one: a hum with something
under it that you can't quite make out.

## 2. Where the lore supports expanding the pages

1. **Where the red lamp is (most important for the finale).** The finale needs the player to go to
   wherever the lamp is kept, but the only clue is one line in `forum/upper/order`: "Levi brings the
   Grange's red lamp up from **the vault**". Nothing says what or where the vault is, and Strand Title's
   SOS page gives no business address. Some options:
   - a `strandtitle.com` page (fireproof document vault, "after-hours closings by appointment", address)
   - a BidHaus member page for **h\*\*\*e** (0 feedback, a "local pickup" note, or a WTB post tied to Strand)
   - a line in the WS_FTP log or a `/backup` row that places `lamp_09`/`lamp_10` or "the vault" somewhere

   Whether "up from the vault" means below 412 or somewhere off the lane is for you to decide.
2. **Tie C. Hale to Miriam.** The Book of the Watch is signed "C. Hale, Master, 1911", and Miriam is née
   Hale and "has read the whole book". No page connects the two. A single caption on Miriam's scrapbook
   ("Great-grandpa Hale, Grange Master, 1911"), or a line on Clarence's page listing the Masters, would
   explain why Miriam is "the last one who can still choose".
3. **Transcribe the rest of the microfilm queue.** `millbrookledger.com/archive` lists reels that were
   never transcribed:
   - **1911 charter ceremony (reel 3):** ten lamps lit for the first time, and C. Hale as Master.
   - **1977 "Grange hall sold to local minister" (reel 41):** a 23-year-old Crane, "eleven people in my
     living room".
   - Keep the **1987 reel missing**, because its absence is the clue.
4. **Pruitt prospering after 1931.** Lore says "Pruitt came back up and prospered", and horn_ii brags
   about it, but no document shows it. For example, a 1932 or 1933 Ledger item has E. Pruitt buying the
   Drury farm, or the Strand widow's acreage, at auction. Gary Pruitt's obituary and Gloria Pruitt (the
   Recorder) already continue the family line.
5. **Ben Talley's last story (1992).** The 1991 editorial promises a follow-up and the staff page says
   his notes were never found. A 1992 archive stub with his last byline, or an unfinished draft about
   the Lindqvist families renting from Crane Holdings, would give the player a predecessor to follow.
   Abel's "clean title (VERY clean lol)" cars suggest a tow-yard angle too.
6. **Kettering Insurance, and Hannah's policy.** The lore beat "If He asks for more, there's Hannah's
   policy" is only hinted at: an anonymous "read your own policy" comment, and Owen's Tape 7. A small
   agency site with a "policy lookup by name" form, or a leaked declarations page (insured: Hannah R.
   Kettering; beneficiary: Evangelicals International; written 07/2004 by A. Kettering), would make the
   hint land.
7. **Nathaniel Drury, shut out of the Upper Room.** He's the webmaster, horn_iii, and Tobias Drury's
   descendant, but he is only ever seen through other people's comments ("N. does not have the
   password"). A post in the Lower Hall, or a source comment where he notices he can't see a category,
   would bring out the split between the seven and the four.
8. **The families that kept their lamps lit in 1931.** Hale, Mercer, Pell, Finch and Kettering kept
   their lamps lit, and their grandchildren are now among the seven unwitting doors. One page that
   notices this (Clarence's page, or `~harmonic`) would add a lot of irony at little cost. Isaac's line
   "his boy won't go into the round room anymore" could be expanded on Jonah's journal after 10/13.
9. **Channel 3 at 3 AM** (a brick wall, a lamp, a voice counting to eight) is only mentioned in gripes.
   A Millbrook Cable overnight listings page or a community-access schedule would give it a place of its
   own.

### Consistency flags (not edited)
- **"New owner at 411."** Lore and the staff page say the player was hired and moved in in **March
  2003**, but the HOA admin queue, the Fall 2004 newsletter ("Welcome, New Neighbor!"), `forum/watch`
  ("the new one") and Paul's 10/12 log ("Turns out he writes for the Ledger") all treat the player as
  newly arrived in fall 2004. Either shift the move-in date or reword these to something like "the one
  who moved in last spring".
- **Carol's open letter** ("The candles and the robes and the room under the ground were real... Somebody
  showed them.") comes close to the tone rule that abuse is only ever an accusation the church
  manufactures and is never shown. It works if "showed them" means *showed them the room*, but you may
  want to make that explicit.

## 3. Staccato prose: what was changed

I left the characters' voices alone. The crank page, the teens, Steve, Ron and the villains' forum
aphorisms are clipped on purpose. I only changed chains of three or four fragment sentences that read
like narration tics, and one repeated joke format ("X says Y. X is correct.").

| Page | Before | After |
|---|---|---|
| `letters/2004-09-hoa` | I am paying the fines. I will keep paying them. I know how these men work. I used to sit at their table. | I am paying the fines, and I will keep paying them, because I know how these men work. I used to sit at their table. |
| `~prennick/log` 09/24 | ...from the shed. Didn't speak. Didn't move. I went inside... | ...from the shed, not speaking, not moving, just facing the house. I went inside... |
| `~prennick/log` 10/08 | ...kept shaking. Something is coming up through the pier. 3:15 exactly. It isn't traffic. There's no traffic on Harrow at 3:15. | ...but at 3:15 exactly the image started shaking, and it was coming up through the pier. I'd blame traffic if there were ever any traffic on Harrow at 3:15. |
| `~prennick/log` 10/14 later | I waved. Nobody waved back this time. ...wasn't in the car tonight. I hope that means something good. | I waved, and this time nobody waved back. ...wasn't in the car tonight, which I hope means something good. |
| `millnet/support` (Rick) | The line is clean. The noise isn't on the line. It's in the conduit... / ...at night. Please stop calling about this. We can't fix it. It isn't ours. | The line itself is clean. Whatever the noise is, it's in the conduit... / ...at night, so please stop calling about this. We can't fix it, because it isn't ours. |
| `millbrookcarecenter.com` | ...switched off at 3:15 AM. The bulb was fine. We don't know who turned it off. | At 3:15 AM the night nurse found Wendell's hall light switched off. The bulb was fine, and none of our staff had touched the switch. |
| `mvole/1997` | He counted everything twice. So did I. That was the problem. / The court called it theft. It was a purchase. | He counted everything twice, and so did I, only I wrote mine down in two different books. / The court called it theft, but it was really a purchase. |
| `forum/pastor` | So yes. I am still myself. That is the worst thing I can tell you. | So yes, Levi, I am still myself, and that is the worst thing I can tell you. |
| `forum/horns` | Let them keep it. Fear fills pews. Fear sells houses. | ...so let them keep it. Fear fills pews, and fear sells houses. |
| `priya_n` | sound does not care what color a light is. i don't have a hypothesis. i have a data set i don't like. | sound shouldn't care what color a light is. i don't have a hypothesis, just a data set i don't like. |
| `kayleigh_s` | he says don't ask him why. he doesn't know why. he just knows. / My mom says it is "a lot." My mom is correct. | he says don't ask him why, because he doesn't know why, he just knows. / My mom says it is "a lot," which, fair. |
| `~carolq` | ...houses now. I hope they're warm. I do not forgive the grown-ups. Not yet. / They just weren't mine. Those children didn't make them up. | ...houses now, and I hope they're warm. I have not forgiven the grown-ups, and I'm not sure I ever will. / They just weren't mine, and those children didn't make them up. |
| `medialab/ohart` | Priya says it's the mic. Priya is probably right. | Priya says it's the mic, and she's probably right. |

I kept one instance of the "X is a lot" joke (Jess's "owen is a lot"), because it's the best of them.
