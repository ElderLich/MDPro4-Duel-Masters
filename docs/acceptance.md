# Development acceptance — 7 November 2026

This is the first maintained compatibility package, not complete paper-DM or
modern Japanese OCG acceptance. The original files were committed before edits.
Neither the original ygopro-dm checkout nor the MDPro4 host source was modified.
No repository was pushed and no remote release was published.

## Source and package

- Original import: 1,067 files hash-verified against the requested local source,
  excluding textures and DataEditorX; baseline commit `ceced49`, upstream tag
  `upstream/a047df9`. GPL license and authors retained.
- 1,021 database records with integrity, matching data/text rows, unique IDs,
  alias closure and gameplay script closure checked. The four explicitly known
  race-reference records are not playable. No ID collisions with the installed
  English standard, Rush or Edison catalogs.
- 1,017 card scripts and two namespaced DM helpers. The YPK excludes the two
  upstream stock core Lua replacements and global translation/banlist overrides.
- 15 immediately usable starter decks included. All 35 original deck files
  remain in source; set catalogs and the two side-deck variants are omitted from
  the package and explained in its manifest.
- 124 exact-ID full card scans included out of 3,413 supplied images. The other
  897 database IDs have no accepted image mapping. Scans are preserved as full
  scans; UUID or unrelated numeric filenames are not guessed.
- Fourteen Python tests cover identity/ambiguity, changed hashes, path bounds,
  image classification, prompt IDs, SQLite/script closure, deck eligibility,
  byte-exact packaged CDBs and reproducible ZIP creation. All passed.
- All 1,021 expansion Lua source files syntax-compiled. The 155 Lua regressions
  passed: 72 deck-start cases, 13 breaker-selection cases, 64 shield-slot cases and six evolution-group cases.

## Native core

Tested the packaged scripts against the deployed Windows DLL, SHA-256
`51287007cb534e89443e3990c6e97629a163b36165f5443ed8d23f72173d47cc`,
with installed host scripts SHA-256
`7638c79ebcc7fbfa03980a3cf32375558d2633fd053de2b8f8c2ecff372885cb`.

All 1,017 playable records initialized through 1,006 canonical scripts plus
eleven aliases, with no Lua diagnostics. Repeated helper loads preserve wrapped
function identity, `type()` stays unchanged globally, and a new duel receives a
fresh helper state. Native seed reproducibility was checked.

Both isolated opening settings (0 initial hand / 0 host draw) and normal host
settings (5 initial hand / 1 host draw) reach five face-down shields, five cards
in hand and 30 cards in deck for each player. The rules card occupies field slot
5 and shields use stable slots 0–4. There are zero shield identity hints and zero
placement requests. A real response declining the optional mana charge and pass
responses to empty optional chain windows continue to the idle command.

The normal-host fixture caught and now guards a native Group-iterator invalidation
in movement helpers. Evolution sources are collected before the target group is
mutated. Both fixtures pass after that correction. This is actual native
continuation evidence, not only mocked callback execution.

## Connected Unity

MDPro_3 was connected in Unity 6000.4.4f1, idle in the Main scene. An isolated
instance of the existing `MDPro4.IO.ZipManager` mounted the real YPK, read a DM
helper and card scan, and found all three CDBs. Disposal retired its index and
released the archive for exclusive access; reinitialization read the rules card
again. Cleanup completed and the Console contained no warnings or errors.

The test did not replace the global resource manager, install the package into
the live player's expansion collection, change settings, enter Play, restart
Unity or build a player. No new Unity asset, material or shared texture lifetime
was introduced. A supplied scan was inspected as a complete printed DM card.
This does **not** certify its final rendered appearance: the current host still
uses YGO crop/frame logic for this picture path.

## Remaining acceptance and design

The package is suitable for further development and private compatibility tests.
The following are not complete:

1. A dedicated Duel Masters mode with direct starter installation, DM zone names,
   native full-card presentation, and no manual deck-check override.
2. Numbered shield backs with safe selection/inspection and one multi-break
   confirmation; clean Shield Trigger choices. Hidden identity must be excluded
   from host previews and network views until an authoritative reveal permits it.
3. More than five shields, unrestricted creature zones, correct attack-time
   tapping, and modern extra-zone/mechanic support. These need authoritative
   engine and protocol work; adding visual slots cannot implement the rules.
4. Live four-copy/name checks with card-text exceptions, current restriction
   formats, complete card interaction tests, full games, multiplayer secrecy,
   saved/reloaded replay playback and non-Windows core acceptance.
5. Reviewed mapping and rendering of the remaining artwork.

See the [rules audit](rules-audit.md) and [host integration design](mdpro4-integration.md)
for source references, specific ownership and next implementation boundaries.
