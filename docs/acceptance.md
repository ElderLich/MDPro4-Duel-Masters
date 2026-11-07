# v0.2.0-preview.1 acceptance — 7 November 2026

This preview covers the inherited card pool and a bounded local MDPro4 host
integration. It does not establish complete paper-DM or modern Japanese OCG
conformance. The original ygopro-dm checkout remains untouched; its files were
committed before modernization. Host changes are maintained locally in
`MDPro_3`, branch `Duel-Masters` at `e84c3009c`. This host branch has not
been pushed, and no compiled game-client update is delivered by this YPK.
Versioned package downloads belong in
[GitHub Releases](https://github.com/ElderLich/MDPro4-Duel-Masters/releases).

## Source and package

- Original import: 1,067 files hash-verified, excluding textures and DataEditorX;
  baseline commit `ceced49`, upstream tag `upstream/a047df9`. GPL license and
  original-author attribution remain intact.
- 1,021 database records with integrity, matching data/text rows, unique IDs,
  alias and script closure checked. Four race references are not playable.
  No collisions were found in the inspected English standard, Rush or Edison
  catalogs; future host databases still need collision checks.
- 1,017 card scripts and two namespaced helpers. Manifest `card_ids` explicitly
  identifies the DM collection for the host. Stock core Lua replacements and
  global translation/banlist overrides are excluded.
- Fifteen usable starter decks are packaged. The 35 source deck files include
  set catalogs and two side-deck variants that are excluded from the playable
  package and explained in its manifest.
- 124 approved full-card scans from 3,413 supplied images. The other 897
  database IDs have no accepted mapping. Original JPEG scans remain intact;
  UUIDs and unrelated numbering are not guessed. No approved DM card back was
  found, so the host retains the existing card protector.
- Fifteen Python tests passed, covering artwork identity, ambiguity, hashes,
  path bounds, prompt IDs, database/script closure, deck eligibility, manifest
  membership, byte-exact packaged CDBs and reproducible packaging.
- All 1,021 expansion Lua source files syntax-compiled. All 155 Lua regressions
  passed: 72 deck-start, 13 breaker-selection, 64 shield-slot and six
  evolution-group cases, using the explicitly supplied trusted Lua library.

Release builds use
`Releases/v<VERSION>/MDPro4-Duel-Masters-v<VERSION>.ypk` and a SHA-256 sidecar.
Development candidates stay under `build/`; published tags and payloads are
immutable. See [release procedure](releases.md).

## Native core and complete games

Tested against deployed Windows core SHA-256
`51287007cb534e89443e3990c6e97629a163b36165f5443ed8d23f72173d47cc`
and host scripts SHA-256
`7638c79ebcc7fbfa03980a3cf32375558d2633fd053de2b8f8c2ecff372885cb`.

All 1,017 playable records initialized through 1,006 canonical scripts plus
eleven aliases, without Lua diagnostics. Repeated loads preserve helper/wrapper
identity, `type()` remains unchanged globally, and a fresh duel receives fresh
helper state. Native seed reproducibility passed.

Both isolated opening settings (zero host hand/draw) and normal host settings
(five initial cards, one draw) produce five face-down shields, five cards in
hand and thirty cards in deck per player. Shields use actual slots 0–4; the
rules support card occupies field slot 5. Setup emits no shield identity hints
or placement requests. Real charge/chain responses continue native execution.
Movement helpers collect evolution sources before mutating groups, preventing
the native iterator failure found during opening QA.

Five full-duel cases passed against the candidate YPK. Each uses legal
forty-card fixture decks plus the engine-only rules card, ordinary core offers
and responses, actual mana charges, summons, attacks and a normal win. Every
case ended on turn nine; no state or winner was injected.

| Case | Observed result |
| --- | --- |
| Creature Shield Trigger accepted | One offer, activation and resolved creature summon. |
| Creature Shield Trigger declined | One offer and zero trigger activations. |
| Spell Shield Trigger | Two Tornado Flame resolutions destroyed two creatures. |
| Double breaker | Two actual multi-shield break selections. |
| Full battle zone | A creature trigger shield broke with five occupied creature slots; the duel completed in 283 responses. |

The full-zone fixture caught an infinite failed-summon reoffer. The trigger's
target predicate now checks actual free battle-zone capacity. The failing seed
completes after the correction; its failure evidence was retained.

Each case writes a standard uncompressed YRP1 file, reads that file from disk,
and replays its recorded seed/decks/responses through a fresh native duel.
All five replays consumed every response and reproduced the full native packet
stream exactly, with zero Lua diagnostics. Source/YPK database and helper bytes
also matched. See [full-duel QA](full-duel-qa.md) for the command, hashes and
assertion details. This native replay proof is separate from Unity playback.

## Local host rendering and shield privacy

Connected Unity 6000.4.4f1 passed the following bounded host checks:

| Area | Verified checks |
| --- | --- |
| Printed cards and resource ownership | 12 rendering/lifetime checks. |
| Shield identity and reveal scopes | 26 privacy checks. |
| DM card information | 13 fact/formatting checks, sidebar/full-reader screenshots and standard-card restoration. |
| Shield-count HUD | 10 checks covering counts and normal-mode restoration. |
| Field shield selection | 28 handler checks, including exact response `020102` and cleanup. |

These are runtime and handler assertions, not complete multiplayer or
physical mouse/gamepad acceptance.

The mounted package manifest and runtime must come from the same archive.
Explicit catalog membership selects the full printed-card path without treating
an arbitrary numeric range as DM. The host keeps the source scan's frame and
proportions, bypasses YGO frame/foil composition for DM, and handles missing
scans through the existing fallback. Normal YGO rendering remains available.
Texture/cache ownership stays in the existing loader and view leases.

The sidebar and full reader share `DuelMastersCardFacts`: Creature, Evolution
Creature or Spell, actual civilization/race labels, mana cost and creature
power. The host suppresses inappropriate YGO stars, ATK/DEF, attribute and
format chrome and displays the package's unmodified rules text without a
false YGO archetype/series annotation. Unknown race chunks are omitted rather
than interpreted as YGO archetypes. Switching back to a standard card restores
the normal information display.

The public rules support card activates DM presentation without drawing an
extra field model. Shields keep stable numbers; creatures use DM power labels.
Both players' face-down shield identities are protected in previews, sidebar,
card lists, selection popups and ordinary/free replay views. Selection offers
do not assign the hidden IDs they contain. Face-up shields remain public.

An actual `ConfirmCards` event grants a temporary reveal for the exact physical
card and permitted recipient. Private opponent confirmations are visible only
under explicit replay God View; spectator mode does not reveal them. Reveal
leases end on disposal, movement, identity/controller/slot changes or reset.
The normal core selection indexes are preserved; a multi-shield choice remains
reviewable and requires one confirmation. Selected numbers remain bold cyan
and clear on deselection, movement or response retirement.

The HUD displays `Shields: <count>` from actual S/T slots 0–4. Updates follow
committed movement, replay reload/reset and LP-event boundaries; no per-frame
polling or fabricated shield state is used. The normal LP view is hidden and
restored per instance, and the compatibility LP value no longer creates a
false low-life warning. Native LP, damage and winner state are unchanged.

The selection fixture replayed an actual native multi-break offer containing
physical shield slots 1–4. Real `PlaceSelector.OnClick` and the Unity Confirm
button callback selected/revised the group to physical slots 2 and 3, then
serialized `020102`: two selected cards at offered indexes 1 and 2. A rapid
second confirmation did not submit twice, hidden identities stayed private
and owned state was restored. This was a handler fixture on a paused real
replay, not new native game progression or physical pointer-raycast testing.

### Actual Unity saved-replay playback

All five final saved files passed through the host's real replay player:

| Replay | View | Result |
| --- | --- | --- |
| Double breaker | Normal | Turn-nine win and completed exit. |
| Creature trigger accepted | Normal | Turn-nine win and completed exit. |
| Creature trigger declined | Free View | Turn-nine win and completed exit. |
| Spell trigger | Normal | Turn-nine win and completed exit. |
| Full battle zone | Free View | Turn-nine win and completed exit. |

Each run reached the actual result panel, completed its Next-button
confirmation/end notification and finished `WaitForDuelExit`. All observed
hidden-shield checks and movement-driven HUD/count comparisons passed.
Borrowed settings were restored, replay views closed, and no active duel
remained after QA. The final Console contained zero warnings and errors.
Seeking and physical pointer/gamepad input were not certified by this pass.

## Remaining boundaries

1. The accompanying host integration is local source work, not a distributed
   MDPro4 player release. A dedicated DM room/deck flow, automatic starter
   installation and complete zone terminology remain incomplete.
2. The adapter has five actual shield slots. Five occupied creature slots were
   exercised; unrestricted battle zones, more shields, attack-time tapping and
   newer extra-zone mechanics require authoritative engine/protocol work.
   Full-field evolution through effects/Shield Trigger is a preexisting
   unsupported path, including Q-tronic's printed trigger and Wolfis's
   separate granted-trigger path; see [full-duel QA](full-duel-qa.md).
3. Multiplayer secrecy and server redaction have not been tested. Local display
   guards cannot establish network confidentiality. The own-shield random
   selection compatibility workaround remains in Lua.
4. Live four-copy/name exceptions, current restriction formats, every card
   interaction, blocker/evolution combinations, replay seeking, physical
   pointer/gamepad input and non-Windows cores remain outside this pass.
5. 897 database IDs still lack reviewed artwork, and no DM-specific protector
   is supplied. Additional cosmetic field assets are not part of this release.

See the [rules audit](rules-audit.md) and [host integration contract](mdpro4-integration.md)
for source ownership and the remaining implementation boundaries.
