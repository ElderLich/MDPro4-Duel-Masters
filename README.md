<div align="center">

# MDPro4 · Duel Masters

**The classic Duel Masters collection, brought into MDPro4.**

1,017 card scripts · 15 starter decks · Standard `.ypk` packaging

**Development preview — existing card pool first**

[Get started](#play-a-private-test-game) · [Build](#build-the-pack) · [Scripting guide](docs/scripting-guide.md) · [Rules audit](docs/rules-audit.md) · [Validation](docs/acceptance.md)

</div>

A community continuation of **YGOPro-DM by Hello23-Ygopro and szefo09**.
Their card collection, scripts and research are preserved while the runtime is
updated for MDPro4. The original GPL-3.0 license and author credits remain part
of the project. [Credits and provenance →](NOTICE.md)

The first target is the existing DM-01–DM-13-era collection and game-original
extras. Newer Japanese mechanics need their own implementation and tests; this
preview does not claim complete modern Duel Masters support.

## What works today

| Area | Current implementation |
| --- | --- |
| Collection | 1,021 database records: 1,017 playable records and four race references. |
| Loading | Archive-aware scripts, one shared runtime per duel, native seeded randomness. |
| Opening shields | Five face-down shields per player in stable slots, without placement prompts or setting changes. |
| Rule corrections | Exact deck size, consistent invalid-deck outcomes, correct breaker choices and safe movement-group iteration. |
| Prompts | 50 isolated DM descriptions instead of replacing shared YGO labels. |
| Starter decks | 15 validated decks packaged; historical catalogs retained in source. |
| Scans | 124 exact matches with source hashes; other images await reviewed mappings. |
| Validation | Python and Lua checks, all playable records initialized in the deployed core, real opening responses and Unity archive lifetime checks. |

**The interface is still a compatibility adapter.** Mana and shields use existing
YGO zones, and the host uses YGO crop/frame logic for these full-card scans.
Dedicated DM presentation, unrestricted zones, full-game multiplayer and replay
acceptance remain open. [Exact tested scope →](docs/acceptance.md)

## Play a private test game

1. Put `MDPro4-Duel-Masters.ypk` in MDPro4's **`Expansions`** folder. Enable
   expansions and restart so both archive readers discover it.
2. Open the YPK as a ZIP and copy one of its **`deck/*.ydk`** files to MDPro4's
   **`Deck`** folder. Embedded decks do not automatically appear in the picker.
3. Host a private standard duel with deck checking disabled for this legacy
   adapter. Both participants should use the same package.
4. Use **40 DM cards plus one Duel Masters Rules card** (`24000000`). The script
   removes the support card from the playable deck, prepares the opening hand
   and deals the shields automatically.

The source `deck/` directory also contains set catalogs and two starter variants
with side cards. They are preserved but omitted from the playable package; its
manifest explains why. Disabling host deck checks does not establish complete
paper deck legality or current restriction-list compliance.

### How shields should feel

Opening shields belong to setup, not ten separate placement decisions. That is
already automatic. Existing shields retain their slots when another is added.

The next host layer should show numbered card backs, one clear multi-break
confirmation and a separate Shield Trigger decision when permitted. Hidden
shields must not expose names or previews. More than five shields requires real
engine support, not extra visual slots. [Shield and zone design →](docs/mdpro4-integration.md)

## Build the pack

Requires **Python 3.11+**. Pillow is needed only when an approved image requires
JPEG conversion. Existing JPEG scans stay byte-identical; source images are
never cropped or overwritten.

```powershell
# Build scripts, databases, prompts, decks and documentation.
python tools/build_package.py

# Run portable checks.
python -m unittest discover -s tests -p "test_*.py"
```

Output: **`dist/MDPro4-Duel-Masters.ypk`**, with a SHA-256 sidecar.

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
<summary><strong>Validate against the installed MDPro4 core</strong></summary>

```powershell
python tools/core_smoke.py --core "<ocgcore.dll>" --host-scripts "<script.zip>" --package "dist/MDPro4-Duel-Masters.ypk" --report build/native-check.json
python tools/run_lua_tests.py --lua lua
```

Use `--lua-dll <trusted Lua 5.3/5.4 library>` when no Lua executable is installed.
The native harness checks initialization, helper lifetime, seeded randomness and
opening continuation with isolated and normal host settings. It does not certify
every card interaction or full replay playback.

Pass `--host-cdb <cards.cdb>` to the builder, repeating it for each host catalog,
to reject card-ID collisions before packaging.

</details>

The builder uses an explicit payload, sorted entries, fixed ZIP timestamps, CRC
verification and atomic replacement. The embedded manifest records payload and
artwork hashes. Legacy stock Lua replacements, client-wide translations,
historical banlists, `pack.db`, textures and DataEditorX are not installed over
MDPro4.

## For scripters

**[Duel Masters scripting guide](docs/scripting-guide.md)** explains the current
card-data contract and scripting APIs used by this package.

It covers the current loader template, card types, civilizations, zones, phases,
format flags, database category bits, helper conventions and validation.
Adapter encodings are distinguished from paper rules and unimplemented host
behavior.

| Reference | Purpose |
| --- | --- |
| [Scripting guide](docs/scripting-guide.md) | Write and maintain cards with the current DM helper. |
| [Rules audit](docs/rules-audit.md) | Official sources, corrected defects and known rule differences. |
| [Runtime compatibility](docs/runtime-compatibility.md) | Native APIs, lifetimes and deployed-core evidence. |
| [MDPro4 integration](docs/mdpro4-integration.md) | Artwork, prompts, shields, rendering and resources. |
| [Acceptance](docs/acceptance.md) | What passed and what remains untested. |
| [Card set catalog](SETS.md) | Card coverage and set information for the included collection. |

Changes belong in small, separately named commits describing the behavior,
reason and validation. Preserve attribution, hidden-card boundaries and the host
protocol. Loader-only checks are not complete rules conformance.

## Credits

Original implementation: **Hello23-Ygopro** and **szefo09 / Szefo09**,
[YGOPro-DM](https://github.com/szefo09/ygopro-dm).
The imported baseline is tagged **`upstream/a047df9`**; original files were
committed before modernization began.

Duel Masters names, card text and artwork belong to their respective rights
holders. This unofficial community project's source-code license does not assert
ownership of those assets.

[Full attribution](NOTICE.md) · [GPL-3.0 license](LICENSE)
