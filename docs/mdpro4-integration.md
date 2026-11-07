# MDPro4 integration contract

Source inspection: 7 November 2026. Host checkout:
`D:/Programs/GitHub/MDPro_3`. These findings distinguish package loading,
core execution, and rendered gameplay; a valid YPK proves only its own scope.
Host modifications and connected-Editor acceptance, if any, are recorded separately by the integration owner.

## Package layout and lookup

A normal `.ypk` is a ZIP file placed in the host's `Expansions/` directory,
with expansions enabled. The ZIP contains runtime paths directly, without an
outer repository or `expansions/` directory:

| Content | Archive path | Host owner |
| --- | --- | --- |
| Card scripts | `script/c<id>.lua` | `PercyOCG.ScriptHandler` / core reader |
| DM helper scripts | `script/dm/utility.lua`, `script/dm/constants.lua` | The guarded DM bootstrap |
| Card databases | Unique `*.cdb` basenames | `CardsManager.LoadDatabase` and temporary extraction |
| Full printed card scans | `pics/<id>.jpg` | `ResourceManager.GetCardImageAsync` |
| Isolated illustrations | `art/<id>.jpg`, `art2/<id>.png` | `ResourceManager.GetCardIllustAsync` |
| DM descriptions | Uniquely named `*.conf` | `StringHelper.AddExpansionStrings` |

Relevant host sources are `Assets/Scripts/MDPro4/Core/Data/FileGroupConfig.cs`,
`Core/IO/ResourceManager.cs`, `Core/IO/FileManager.cs`, `Core/IO/ZipManager.cs`,
`Duel/YGOSharp/CardsManager.cs`, and `Duel/PercyOCG.cs`, relative to that checkout.

Loose files win over archive entries. Archive paths are indexed without case
sensitivity, and the first archive providing a path wins; filesystem enumeration
is not a portable override policy. This package therefore owns a distinct DM
helper namespace and distinct CDB basenames. Do not bundle replacements for the
host's `script/constant.lua`, `script/utility.lua`, or `script/procedure.lua`.
A source check found no ID collision between the 1,021 imported DM IDs and the
checked-out `Data/locales/en-US/cards.cdb`; that is a snapshot, not a guarantee
about future databases or other installed packs.

CDB readers extract to a flat temporary directory, so distinct archive folders
cannot protect duplicate CDB basenames. SQLite source inspection opens read-only
connections and closes each connection explicitly. The tooling never edits the
original artwork or source databases during inventory.

## Lua and authoritative state

The deployed Windows core capability probe reported `Duel.LoadScript`,
`Duel.GetRandomNumber`, and `GetID`; `require` and `debug` were absent. The sibling
`ygopro-core` source lacks some of those APIs and is not sufficient evidence for
the deployed DLL. Use the actual binary smoke receipt when claiming compatibility.
The migrated DM bootstrap loads uniquely named helper scripts through the core's
script reader instead of Lua filesystem module loading.

The legacy mod encodes battle creatures as monster-zone cards, shields as
spell/trap-zone cards, untapped mana as graveyard cards, and tapped mana and the
DM graveyard through banished-card state. These are adaptations of the YGO core,
not native Duel Masters zones. The existing five shield / six creature limits,
concealed tapped mana, response pauses, attack tapping, and replay behavior need
explicit gameplay acceptance; do not infer them from database or script loading.
No host message parser, movement format, shared-state owner, or replay policy was
changed here.

For a bounded real-core fixture, follow the callback ABI and packed card fields
in `Tools/MasterDuel/tests/summon_history/ocg_fixture.py`. Feed the actual generated
YPK through script/card callbacks and the host's normal base script archive;
capture all Lua diagnostics. Exercise setup, responses, and state queries, then
retire the duel and release callback buffers. A generated-and-reloaded replay is
a separate required proof for any future replay-state change.

## Artwork mapping and display limitations

The supplied collection is `G:/Modding/Duel Masters/DM Sets`. Inventory found
3,413 supported images and seven unrelated `Thumbs.db` files. There are 253
numeric filename stems, but only 124 match imported card IDs. All 124 matches
come from `DM-01`; 897 imported IDs have no approved mapping. The remaining
numeric filenames use a different ID scheme (for example `10013001`), and most
other filenames are UUIDs. Directory order, guessed prefix substitution, and
fuzzy name similarity are not identity evidence.

The inspected `DM-01/24001001.jpg` is a complete printed Duel Masters card,
including frame, rules, collector number and illustrator credit. The initial
packaging classification is therefore `full_card`; original JPG bytes belong
in `pics/`. The tool requires this classification explicitly, and reviewed
per-card mappings can identify future isolated `artwork` inputs.

`tools/artwork.py` accepts only an exact numeric card ID or an exact uniquely
normalized card name (Unicode NFKC, case folding, collapsed whitespace;
punctuation is retained). Multiple images for an ID or a repeated card name
remain ambiguous. Reviewed mappings in `config/artwork-map.json` must contain
`card_id`, relative `source`, the expected `sha256`, and `image_kind`.
A changed source hash or a path outside the source directory fails validation.
Explicitly selected sources are not reused by automatic matching.

The generated manifest records source path, source SHA-256, card ID, image kind,
archive path, and required encoding for every accepted mapping. PNG/WebP scans
require actual JPEG encoding because the host's `pics/` group only accepts JPG;
renaming bytes is insufficient. PNG isolated artwork can remain byte-identical
under `art2/`. The inventory performs no crop, resize, image generation, or
in-place source rewrite.

Current MDPro4 `Utility/CardImageLoader.cs` crops `pics/` using Yu-Gi-Oh! geometry
and composes a Yu-Gi-Oh! frame. It has special Rush/Pendulum paths, but no Duel
Masters frame/crop owner was found. Consequently this initial standard YPK
retains the complete source scans but does not establish faithful DM rendering.
A future DM presentation path should use explicit card-family identity and the
existing texture cache; it must not reinterpret every expansion image as DM.

## Resource lifetimes

`ZipManager` owns open archive objects, guards each extraction with its archive
lock, cancels its generation on disposal, and drains readers before disposal.
Do not unload a shared archive to work around one missing DM image.
`ResourceManager` creates a fresh decoded texture and transfers ownership to
`CardImageLoader`. The cache grants reference-counted leases; views borrow the
texture and balance `ReleaseArt` / `ReleaseCard`. Cropping destroys the temporary
scan after creating the cropped texture. Material and cache ownership remain
with the host; the YPK imports no Unity asset bundles, GUIDs, or prefabs.
Relevant precedent includes host commits `67303252d` (archive reader retirement)
and `a780c73f1` (portable artwork and archive priority).

## Strings and menus

Legacy `strings.conf` contains replacements for shared low-numbered system
strings, including phases and zone names. MDPro4 loads its own locale strings
first and retains the first matching region/ID, so those old replacements are
not isolated per-duel localization. The fork now distributes `expansions/mdpro4-dm-strings.conf`: 50 DM-specific
system descriptions use `8000 + legacy ID` (8002 through 9803). Corresponding
`DM_DESC_*`, `DM_DECKERROR_*`, `DM_HINTMSG_*`, and `DM_QHINTMSG_*` literals were
migrated together; existing `aux.Stringid` card descriptions were retained.
`DuelMessage.GameMessage_Hint` reads a 32-bit description and calls
`StringHelper.Get(int)`. That function treats values below 10000 as system IDs
and larger values as `card ID << 4 | string index`; an arbitrary large system
namespace would display the wrong text. The selected 50 IDs had no collision
in the inspected host's loose `Data` / `Expansions` configurations. Other
third-party packs still need their own compatibility check.

The dedicated configuration includes victory reasons `0x4d` through `0x4f`
only. Victory reasons are one byte on the wire and are read through the separate
`victory` region. It does not replace standard outcomes 0 or 1. The missing
upstream `DM_DESC_BLOCKED` string was recovered from its existing constant
comment. Whole-client terminology still needs a separate host mode.
`InterString` reads `Data/locales/<locale>/translation.conf`, not an arbitrary
translation file in a YPK. The old `expansions/translation.conf` is preserved as
upstream source, not evidence of working MDPro4 translation. Any future host
string edits must follow its complete catalog/companion synchronization policy.

## Validation recorded here

The artwork regression suite covers exact identity, ambiguity, explicit review,
changed source hashes, path escape rejection, encoding/kind separation,
determinism, and non-reuse of reviewed sources. The real collection inventory
matches the counts above. Connected Unity rendering, complete rules behavior,
multiplayer, other platform DLLs, and replay playback remain separate acceptance
scopes; consult the root task's runtime receipt for checks actually performed.

## Concrete usability work and ownership

The following is the bounded adaptation plan, not a claim that a ZIP alone
changes the host's rules or interface:

1. **Start with a valid playable deck.** The 18 dated set-list YDK files are
   collection catalogs, with 16–60 main cards and no rule card. They are not
   starter decks. Seventeen named starter/theme lists have 41 main entries,
   including the rule card `24000000`, leaving 40 playable cards.
   `DM TCG5 Deadly Decay.ydk` also has 41 entries; its trailing whitespace must
   be stripped when parsing card IDs. The room must allow four copies and accept
   the rule card. Current
   `OnlineRoomCommands.RoomSettings.NoDeckCheck` owns the YGO deck-check bypass;
   the DM rule script remains responsible for actual 40-card validation. A
   later dedicated DM mode should insert the rule card internally and present
   a 40-card count, rather than asking players to understand a 41st support card.
2. **Place hidden shields without a prompt.** `Duel.SendtoSZone` is the Lua
   producer. `DuelMessage.GameMessage_SelectPlace` otherwise uses the latest
   `HINT_SELECTMSG` as a card code and constructs a card-name prompt before
   waiting for player input. Resolve automatic shield placement at the Lua
   producer with an explicit legal S/T-zone mask; do not toggle a player's
   global auto-position preference or hide an already-leaked name later in UI.
   Existing shield-breaking choice is separate: `Duel.BreakShield` emits
   `DM_HINTMSG_BREAK` and selects physical shield cards. Keep this choice;
   `GameMessage_SelectCard` / `PlaceSelector` already own field highlighting
   and response indexes. Back faces must remain back faces until the core
   authoritatively reveals or moves that exact card.
3. **Use DM words for DM choices.** The reserved prompt namespace implements
   mana, tapping, shields, creature selection, deck errors, and optional charge
   wording without overriding normal YGO system messages. A later session mode
   can rename S/T to Shields, Graveyard to Untapped Mana, and the two semantically
   different banished groups to Tapped Mana / Graveyard. That cannot be a global
   location-name replacement: both latter groups share `LOCATION_REMOVED`.
   Derive the distinction from authoritative position/flags used by this Lua
   implementation; maintain exact card identity across `GameMessage_Move` and
   query updates. Never infer hidden identity from the player-visible label.
4. **Keep the printed Duel Masters card.** There is no existing package flag or
   original-picture style: `CardRenderer.CardStyle` contains OCG/TCG, Rush,
   Anime, Sevens Anime, and Manga. The narrow host hook is
   `CardImageLoader.InternalLoadCardAsync`, before `LoadArtAsync` and frame
   composition. For explicit package-declared DM card membership, it can load
   `ResourceManager.GetCardImageAsync(code)` and transfer that fresh texture to
   the existing `cachedCards` owner. Apply bounded thumbnail sizing only when
   requested, keep source scans intact, and retain normal missing-image
   diagnostics. Do not make every card in a broad numeric range use this path.
   Check `CardRawImageHandler.TryGetMasterDuelRenderInfo` and `MaterialLoader`
   too: a native renderer or foil material must not reframe or mask a full DM
   scan. No current `.ini` setting provides this behavior; expansion `.ini`
   texts are consumed by the legacy online page.
5. **Remove adaptation limits only with core evidence.** A larger graphical
   shield row does not remove the five physical S/T slots. Unlimited battle and
   shield zones require an authoritative representation, compatible selection
   responses, move/query semantics, and replay storage. Keep this initial
   YGO-core adapter's limits explicit until that end-to-end work is accepted.

Acceptance for these steps should cover both players, five unrevealed starting
shields with no name-bearing placement pause, charging and tapping mana, a
breaker selecting shields, a real Shield Trigger offer/response, full-scan
rendering at deck and duel sizes, cancellation/reload cleanup, and a saved replay
reloaded to the same public state. A scripted callback assertion does not replace
connected-Editor inspection or actual controller/mouse input evidence.
