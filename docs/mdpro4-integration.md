# MDPro4 integration contract

Implementation reviewed on 7 November 2026 for `v0.2.0-preview.1`, using host
checkout `D:/Programs/GitHub/MDPro_3`, branch `Duel-Masters` at `e84c3009c`.
That host branch has not been pushed. The YPK contains cards, scripts, prompts,
decks and scans. The accompanying rendering and shield interface are local host
changes; this package does not distribute a compiled MDPro4 client update.

Package validation, native gameplay, Unity runtime assertions, actual replay
playback and physical input are separate acceptance scopes. See
[acceptance.md](acceptance.md) for their current results.

## Package identity and lookup

A normal `.ypk` is a ZIP placed in `Expansions/`, with expansions enabled. Its
runtime paths live directly at the archive root, without an outer repository or
`expansions/` directory.

| Content | Archive path | Owner |
| --- | --- | --- |
| Card scripts | `script/c<id>.lua` | `PercyOCG.ScriptHandler` / native reader |
| DM helpers | `script/dm/utility.lua`, `script/dm/constants.lua` | Guarded per-duel bootstrap |
| Card databases | `cards-dm.cdb`, `cards-dm-alias.cdb`, `cards-dm-go.cdb` | `CardsManager` / temporary extraction |
| Full printed scans | `pics/<id>.jpg` | `ResourceManager` / `CardImageLoader` |
| Isolated illustrations, when reviewed | `art/<id>.jpg`, `art2/<id>.png` | Existing artwork loader |
| DM descriptions | Uniquely named `*.conf` | `StringHelper.AddExpansionStrings` |
| Card membership and hashes | `mdpro4-duel-masters/manifest.json` | `DuelMastersCardCatalog` |
| Starter decks | `deck/*.ydk` | Manually copied to the host `Deck/` folder |

`DuelMastersCardCatalog` reads schema version 1 and explicit `card_ids` after
the host publishes its new ZIP index. It checks the package name, unique
positive IDs and the rules card `24000000`. The manifest, all three CDBs, rules
script and both helpers must originate from the same mounted archive. A loose
JSON file or an arbitrary card-ID range cannot activate DM presentation.
Catalog reset/reload changes a revision used by the image cache.

Loose files normally take priority over archive entries; the first archive
providing a path wins. Keep only one active version of the DM pack. Its helper
namespace and CDB basenames are distinct. CDB extraction is flat, so different
archive subdirectories do not protect duplicate basenames. Never package global
replacements for `script/constant.lua`, `script/utility.lua` or
`script/procedure.lua`.

Source databases are inspected through read-only SQLite connections. Card-ID
collision checks passed against the inspected English standard, Rush and Edison
catalogs; run them again for changed host databases or additional packs.

## Lua and authoritative state

The deployed Windows core exposes `Duel.LoadScript`, `Duel.GetRandomNumber` and
`GetID`; its Lua sandbox has no `require` or `debug`. An older sibling core source
checkout is insufficient evidence for that binary. The DM bootstrap loads its
namespaced helpers through the native script reader and initializes once per
duel, without replacing Lua's global `type()`.

The adapter uses monster-zone cards for battle creatures, S/T slots 0–4 for
shields, graveyard cards for untapped mana, and position-dependent banished
cards for tapped mana and the DM graveyard. These are explicit core encodings;
a different label or an extra drawn slot cannot create a new native zone.
There are five actual shield slots. Native QA exercised five simultaneously
occupied creature slots and the resulting no-space summon condition. It does
not establish unrestricted creature capacity, correct attack-time tapping or
modern extra-zone mechanics. Full-field evolution through effects/Shield
Trigger remains an inherited limitation: the effect-summon wrapper requires
space before raising the event that consumes an evolution base. The new
trigger guard prevents an unavailable summon from repeatedly being offered;
it does not implement that base-consumption path. Q-tronic's printed trigger
and Wolfis's separate direct granted-trigger path are documented in
[full-duel QA](full-duel-qa.md).

The rules support card occupies face-up S/T slot 5 and remains in authoritative
state. `DuelMastersSession` activates presentation only when the installed
catalog and that public card agree; the host suppresses its physical field
model. Card membership does not depend on hidden shield identity.

`Duel.SendtoSZone` supplies legal physical placement masks, so shield setup is
automatic and existing shields keep their slots. No global auto-placement
setting is changed. `Duel.BreakShield` remains the producer of a break choice.
The local host consumes its real offered cards and response indexes.

`tools/full_duel_qa.py` runs ordinary offers/responses to actual wins, saves
standard YRP1 files and replays their disk-loaded responses through a fresh
native duel. It retains callback buffers through `end_duel`, fails on unknown
packet boundaries and records Lua diagnostics. A complete native replay match
does not establish host presentation or network redaction.
[Replay ABI and full-duel cases →](full-duel-qa.md)

## Shield visibility and selection

`DuelMastersSession` identifies shields by public session and physical S/T slot,
not by card code. Face-down shields belonging to either player are concealed
through ordinary previews, details, sidebar, card lists and selection popups,
including normal/free replay. A face-up shield is public. Stable labels show
`Shield 1` through `Shield 5`; creature labels use DM power rather than YGO
level/DEF/race overlays.

`GameMessage_SelectCard` and `GameMessage_SelectUnselectCard` do not install
hidden shield IDs from their offer payloads. Field selections toggle the
offered physical cards. Reaching the maximum does not submit automatically:
the player can review the selection and confirm once. The response uses each
card's offered `selectPtr`, not its physical sequence. For example, offered
shields in physical slots 1–4 still use response indexes 0–3. Selected shield
numbers remain bold cyan, then clear on deselection, movement and response
retirement. The actual handler fixture selected physical slots 2 and 3 and
serialized `020102`, with one response despite repeated confirmation.

The duel HUD reads the authoritative shield slots and displays the remaining
count in place of compatibility LP. Committed movement, replay reload/reset
and LP events update the presentation; no per-frame polling is needed. The
native LP label is hidden/restored per view, and the compatibility value does
not cause a low-life warning. This changes presentation only, preserving core
LP/damage/winner state. Normal YGO HUD behavior returns when DM mode ends.

Only an actual `ConfirmCards` event permits a temporary private shield reveal.
The current native packet contains recipient, `skip_panel`, count and card
entries; the older transport parser is not an ABI reference. The permitted
local recipient can see the exact confirmed cards. Opponent-private reveals
require explicit replay God View; spectator mode does not show them.
Reveal leases track card identity revision, movement generation, controller and
slot, and are removed on disposal or session reset. Other shields remain hidden.

These are host presentation protections. Multiplayer secrecy and deployed
server filtering have not been validated. The existing Lua random-selection
workaround for choosing one's own hidden shields remains for compatibility;
removing it requires a negotiated client/core contract and end-to-end tests.

## Full printed cards and artwork identity

The supplied `G:/Modding/Duel Masters/DM Sets` collection contains 3,413 supported
images. Only 124 approved images map to imported card IDs, all from DM-01;
897 database IDs remain unmapped. Other numeric schemes and UUID filenames are
not card identity evidence. No approved DM back was identified, so the existing
selected protector is preserved.

The accepted images are complete printed cards, including their frames, text
and credits. They belong in `pics/`, with original JPEG bytes retained.
`tools/artwork.py` accepts exact card IDs or exact uniquely normalized names
(NFKC, case folding and collapsed whitespace). Reviewed overrides pin
`card_id`, relative `source`, expected `sha256` and `image_kind`. Ambiguity,
changed hashes and paths outside the source directory fail validation.
PNG/WebP full scans require genuine JPEG encoding, not a renamed extension.
Inventory does not crop, resize or overwrite source art.

For explicit catalog members, `CardImageLoader` loads the printed scan before
the YGO illustration/frame composition path. Thumbnail sizing preserves the
whole face. `MaterialLoader`, `CardRawImageHandler`, `CardRenderer`,
`FramePalette` and `GoRushFinish` avoid incompatible native YGO frame, foil,
overlay and video paths for these scans. Missing scans use the existing
owned fallback; an image is never guessed from another card.

`DuelMastersCardFit` fits UI image vertices while retaining layout/hit bounds
and restores normal rendering when the view is reused. `DuelMastersCardModelFit`
adjusts existing front/back/edge surfaces for the public DM session, including
unknown shields. It leaves animation roots, colliders, labels and effects in
their current owners. Hidden identity does not decide a card's physical shape.
Special-effect copies with separate geometry remain outside this bounded
primary-view acceptance.

## Card facts and rules text

`DuelMastersCardFacts` is the shared adapter used by `CardDescription` and
`CardInfoDetail`. It displays Creature, Evolution Creature or Spell, mapped
civilizations, actual races, current mana cost and creature power. Sixty-three
exact `DM_RACE_*` / `DM_SELECT_RACE_*` bindings resolve the package's CDB text
slots; each 16-bit race chunk is decoded explicitly. Unknown chunks are
omitted without falling back to a YGO archetype name. Race label language
follows the loaded package CDB.

The sidebar and full reader hide YGO stars, ATK/DEF, attribute and format
chrome for DM cards, use the package's raw rules description, and restore
normal controls when a standard card reuses the view. This avoids false
archetype/series annotations while retaining the printed scan unchanged.

## Resource ownership

`ZipManager` owns archives, locks extraction and retires readers before disposal.
`ResourceManager` returns a fresh decoded texture to `CardImageLoader`; the
existing cache then owns it and views balance their `ReleaseArt`/`ReleaseCard`
leases. The DM path transfers decoded scans into that same ownership model,
destroys owned temporary textures on cancellation and uses plain material clones
through existing material ownership. It does not unload a shared archive to
handle a missing image. The YPK supplies no Unity prefab or asset bundle.

Relevant host owners are under `Assets/Scripts/MDPro4/`: `Core/IO/FileManager.cs`,
`ZipManager.cs`, `ResourceManager.cs`, `Duel/DuelMastersCardCatalog.cs`,
`Duel/DuelMastersSession.cs`, `Duel/GameCard.cs`, `Duel/Message/DuelMessage.cs`,
`Utility/CardImageLoader.cs` and the existing view/material components.

## Prompts, decks and remaining work

The package supplies 50 isolated DM system descriptions in the range 8002–9803.
Corresponding `DM_DESC_*`, `DM_DECKERROR_*`, `DM_HINTMSG_*` and `DM_QHINTMSG_*`
constants use those IDs. Card descriptions still use `aux.Stringid`:
`StringHelper.Get` treats values below 10000 as system IDs and larger values as
`card ID << 4 | string index`. Victory reasons `0x4d`–`0x4f` use the separate
one-byte victory region; ordinary outcomes 0 and 1 are not replaced.

Global YGO locale replacements are not installed. Host translations belong to
the normal complete locale catalog and companion-data synchronization policy.
The two meanings of `LOCATION_REMOVED` cannot be renamed through one global
zone string. A dedicated DM room/deck flow and complete zone terminology remain
future work. Players currently copy a packaged starter and supply forty DM
cards plus the engine-only rules card, using the host deck-check bypass for
private compatibility testing.

Verified host checks comprise 12 rendering/resource, 26 shield-privacy,
13 card-facts, 10 HUD/restoration and 28 field-selection handler assertions.
Sidebar/full-reader screenshots and return to standard-card presentation
were inspected. All five saved replays also completed through the actual
Unity player, including two Free View cases, result confirmation and exit.
Hidden-shield observations and movement-driven counter checks passed; views
closed, settings were restored and the final Console had no warnings or
errors. See [acceptance.md](acceptance.md). A handler check using real
callbacks is distinct from physical mouse/gamepad input and from live native
flow. Replay seeking was not certified.
Unlimited zones, full card/rules coverage, multiplayer redaction, non-Windows
cores and the remaining artwork mappings are not certified by this preview.
