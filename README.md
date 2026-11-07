<div align="center">

# MDPro4 · Duel Masters

**The classic Duel Masters collection, brought into MDPro4.**

1,017 playable records · 15 starter decks · Full printed cards · Standard `.ypk`

**v0.2.0-preview.1 — existing card pool first**

[Download](https://github.com/ElderLich/MDPro4-Duel-Masters/releases) · [Get started](#play-a-private-test-game) · [Build](#build-the-pack) · [Scripting guide](docs/scripting-guide.md) · [Validation](docs/acceptance.md)

</div>

A community continuation of **YGOPro-DM by Hello23-Ygopro and szefo09**.
Their card collection, scripts and research form the foundation of this MDPro4
adaptation. The original GPL-3.0 license and author credits remain part of the
project. [Credits and provenance →](NOTICE.md)

The first target is the existing DM-01–DM-13-era collection and game-original
extras. Newer Japanese mechanics need their own implementation and tests; this
preview does not claim complete modern Duel Masters support.

## What works today

| Area | Current implementation |
| --- | --- |
| Collection | 1,021 database records: 1,017 playable records and four race references. |
| Loading | Namespaced scripts, one shared runtime per duel, native seeded randomness and explicit manifest card membership. |
| Printed cards | The local host integration displays complete DM scans with their printed frames and proportions. |
| Card information | DM card types, civilizations, races, mana costs and power in the sidebar and full reader, without misleading YGO statistics. |
| Shields | Five automatic face-down shields per player; numbered backs, a live shield counter, protected identities and one confirmation for a multi-shield choice. |
| Rule corrections | Exact deck size, breaker choices, safe movement-group iteration and no repeating creature Shield Trigger when the battle zone is full. |
| Prompts and decks | 50 isolated DM descriptions and 15 validated starter decks. |
| Artwork | 124 approved full-card scans; 897 database IDs still need reviewed image mappings. |
| Native gameplay | Five complete nine-turn games, including creature/spell triggers, a declined trigger and double breaking; all five saved replays reproduce the native event stream. |
| Host checks | Rendering, card information, shield privacy, counters and selection callbacks passed; all five saved replays also completed in Unity with cleanup. |

**The new visuals and shield interface require the accompanying local MDPro4
host integration: branch `Duel-Masters`, commit `e84c3009c`. That branch has
not been pushed, and a compiled game-client update is not distributed by this
YPK.**
The package uses existing core zones: five native shield slots and five occupied
creature slots are covered by actual gameplay tests. Unlimited zones, complete
rules conformance and multiplayer secrecy are not established. The existing
card protector remains in use; no approved DM card-back asset was found.
[Exact tested scope →](docs/acceptance.md)

## Play a private test game

1. Download a versioned YPK and its SHA-256 sidecar from
   **[GitHub Releases](https://github.com/ElderLich/MDPro4-Duel-Masters/releases)**.
   Put `MDPro4-Duel-Masters-v0.2.0-preview.1.ypk` in MDPro4's **`Expansions`**
   folder, enable expansions and restart so both archive readers discover it.
   Replace the previously installed DM YPK; keep only one DM version in
   `Expansions` to avoid duplicate databases. Retain historical downloads in
   `Releases`, outside the active expansion folder. Use the matching local
   host integration for the features described above.
2. Open the YPK as a ZIP and copy one of its **`deck/*.ydk`** files into MDPro4's
   **`Deck`** folder. Embedded decks do not automatically appear in the picker.
3. For a private compatibility test, use a standard room with deck checking
   disabled. Both participants need the same package and compatible host.
   Multiplayer hidden-card transport has not been validated.
4. Use **40 DM cards plus one Duel Masters Rules card** (`24000000`). The script
   removes that support card from the playable deck, prepares the opening hand
   and deals the shields. The local host keeps its logical state without drawing
   it as a physical card on the field.

The source `deck/` directory also contains set catalogs and two variants with
side cards. These are omitted from the playable package; its manifest explains
why. Disabling host deck checks does not establish complete paper deck legality
or current restriction-list compliance.

### Shield handling

Shield setup is automatic. Existing shields keep their physical slots and
numbers. Both players' face-down shields remain hidden in previews, lists and
ordinary replay views. An actual reveal event can temporarily show the exact
permitted card; it does not turn the remaining shields face up. The duel HUD
shows each player's actual remaining shield count instead of the adapter's
compatibility LP value.

Select the offered shields on the field and confirm the whole choice once.
Selected shield numbers stay highlighted until deselected or confirmed. The
choice remains reviewable when its maximum is reached. The host returns the
core's offered indexes, which can differ from physical shield numbers. Shield
Trigger decisions remain separate. More than five shields needs authoritative
engine and protocol work. Full-field evolution through effects or Shield
Trigger is an existing unsupported path; the no-space trigger fix does not
implement it. [Shield and zone contract →](docs/mdpro4-integration.md)

## Build the pack

Requires **Python 3.11+**. Pillow is needed only when an approved image requires
JPEG conversion. Existing JPEG scans remain byte-identical; source images are
never cropped or overwritten.

```powershell
python tools/build_package.py
python -m unittest discover -s tests -p "test_*.py"
```

`VERSION` determines the output:
**`Releases/v<VERSION>/MDPro4-Duel-Masters-v<VERSION>.ypk`**, with a `.sha256`
sidecar. Published tags and payloads are immutable. Use
`--output build/integration-candidate.ypk` for development candidates.
[Release and tag procedure →](docs/releases.md)

<details>
<summary><strong>Include the supplied scans</strong></summary>

```powershell
python tools/artwork.py --artwork-root "G:\Modding\Duel Masters\DM Sets" --map config/artwork-map.json --image-kind full_card --output build/artwork-manifest.json
python tools/build_package.py --artwork-manifest build/artwork-manifest.json
```

Automatic matching accepts exact card IDs or unique normalized card names.
Ambiguous names, unrelated numbering schemes and UUIDs remain unresolved.
Reviewed overrides in `config/artwork-map.json` pin source hashes and distinguish
full scans from isolated illustrations.

</details>

<details>
<summary><strong>Validate native gameplay and saved replays</strong></summary>

```powershell
python tools/build_package.py --artwork-manifest build/artwork-manifest.json --output build/integration-candidate.ypk
python tools/core_smoke.py --core "<ocgcore.dll>" --host-scripts "<script.zip>" --package build/integration-candidate.ypk --report build/native-check.json
python -B tools/full_duel_qa.py --core "<ocgcore.dll>" --host-scripts "<script.zip>" --package build/integration-candidate.ypk --output-dir build/qa/full-duel-run-1
python tools/run_lua_tests.py --lua lua
```

Use `--lua-dll <trusted Lua 5.3/5.4 library>` when no Lua executable is installed.
Use a new full-duel output directory for each run. Its `.yrp` files can then be
opened through the host's actual replay player. Native response replay equality,
Unity playback, rendered appearance and physical input are separate checks.
[Full-duel method and assertions →](docs/full-duel-qa.md)

Pass `--host-cdb <cards.cdb>` to the builder, repeating it for each host catalog,
to reject card-ID collisions before packaging.

</details>

The builder uses an explicit payload, sorted entries, fixed ZIP timestamps, CRC
verification and atomic replacement. The manifest records card membership,
payload and artwork hashes. Stock Lua replacements, client-wide translations,
historical banlists, `pack.db`, textures and DataEditorX are not installed over
MDPro4.

## For scripters

**[Duel Masters scripting guide](docs/scripting-guide.md)** explains the current
loader, card-data contract and helper APIs. It covers card types, civilizations,
zones, phases, format flags, database category bits and validation. Adapter
encodings are distinguished from paper rules and unsupported mechanics.

| Reference | Purpose |
| --- | --- |
| [Scripting guide](docs/scripting-guide.md) | Write and maintain cards using the current DM helper. |
| [Rules audit](docs/rules-audit.md) | Official sources, corrected defects and known rule differences. |
| [Runtime compatibility](docs/runtime-compatibility.md) | Native APIs, lifetimes and deployed-core evidence. |
| [MDPro4 integration](docs/mdpro4-integration.md) | Artwork, shields, manifest identity and resources. |
| [Full-duel QA](docs/full-duel-qa.md) | Reproduce complete games and saved response replays. |
| [Acceptance](docs/acceptance.md) | What passed and what remains untested. |
| [Card set catalog](SETS.md) | Coverage and set information for the included collection. |

Commit each coherent change separately with a descriptive subject and body
covering its reason and validation. Preserve attribution, hidden-card boundaries
and the host protocol. Loader-only checks are not complete rules conformance.

## Credits

Original implementation: **Hello23-Ygopro** and **szefo09 / Szefo09**,
[YGOPro-DM](https://github.com/szefo09/ygopro-dm).
The imported baseline is tagged **`upstream/a047df9`**; original files were
committed before modernization began.

Duel Masters names, card text and artwork belong to their respective rights
holders. This unofficial community project's source-code license does not assert
ownership of those assets.

[Full attribution](NOTICE.md) · [GPL-3.0 license](LICENSE)
