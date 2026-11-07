# Duel Masters scripting guide

Use this guide to add cards, change shared procedures, inspect database fields,
and validate an MDPro4 Duel Masters package. It documents the current constants,
helpers, card scripts, CDB schema, and packaging interfaces.

The tables describe **the adapter's technical encoding inside the Yu-Gi-Oh!
engine**. They do not redefine paper rules. The [rules audit](rules-audit.md)
identifies the selected rules baseline and behavioral gaps; the
[acceptance record](acceptance.md) records the checks actually completed.

## Find the owner before editing

| Source | Responsibility |
| --- | --- |
| [`expansions/constant_dmtcg.lua`](../expansions/constant_dmtcg.lua) | DM names for locations, types, civilizations, races, effects, events, and descriptions |
| [`expansions/utility_dmtcg.lua`](../expansions/utility_dmtcg.lua) | Shared DM procedures and the adapter's `Card`, `Group`, and `Duel` behavior |
| [`expansions/script/c24000000.lua`](../expansions/script/c24000000.lua) | Rules-card startup and shared turn/duel rules |
| `expansions/script/c<id>.lua` | One card's initialization and abilities |
| `expansions/cards-dm.cdb` | Main card data and text, rules card, and race-reference text records |
| `expansions/cards-dm-go.cdb` | Game-original cards |
| `expansions/cards-dm-alias.cdb` | Alias/reprint records |
| [`expansions/mdpro4-dm-strings.conf`](../expansions/mdpro4-dm-strings.conf) | DM prompt descriptions that coexist with the host's system strings |
| [`tools/build_package.py`](../tools/build_package.py) | Explicit YPK composition and catalog/deck validation |
| [`tools/artwork.py`](../tools/artwork.py) | Reviewed artwork identity, source hashes, and image-kind classification |

MDPro4 supplies its own base `script/constant.lua` and `script/utility.lua`.
The package must not replace those files. The builder also excludes the generic
`strings.conf`, `translation.conf`, `lflist.conf`, and `pack.db`; use the explicitly
named DM prompt configuration and package inputs instead of global overrides.

The builder maps the DM helper files to `script/dm/constants.lua` and
`script/dm/utility.lua` in the YPK. Card scripts remain `script/c<id>.lua`; there
is no outer repository directory inside the archive.

## Card database fields

Each card has matching `datas` and `texts` rows with the same `id`. The current
`datas` columns are `id`, `ot`, `alias`, `setcode`, `type`, `atk`, `def`, `level`,
`race`, `attribute`, and `category`. `texts` supplies the name, description, and
card-specific effect strings. Use an existing card with the same mechanic as a
schema example; do not substitute a Yu-Gi-Oh! interpretation for a DM field.

| Database field | Meaning in this adapter | Script-facing owner |
| --- | --- | --- |
| `id` | Stable card/script identifier | `GetID()` through `dm.GetID()` |
| `alias` | Existing alias/reprint identity | Catalog validation resolves the referenced card and effective script |
| `type` | Creature/spell flags and adapter markers | `Card.IsType`, `DM_TYPE_*` |
| `attribute` | Civilization bitmask | `GetCivilization`, `IsCivilization` |
| `level` | Printed mana cost, modified for current play cost | `GetManaCost` reads original level; `GetPlayCost` reads current level |
| `atk`, `def` | Printed creature power, initially equal | `GetPower` reads current attack |
| `setcode` | DM races, using the host's set-code machinery | `DMIsRace`, `DMIsPreviousRace`, `DM_RACE_*` |
| `race` | Host Yu-Gi-Oh! type field; not the DM-race field | Do not fill it merely because a card has a DM race |
| `ot` | Region/source classification | See the OT table below |
| `category` | Card-search metadata | See the category-bit table below |

For example, the current Chilias record (`24001001`) has type `0x21`, civilization
`0x10`, cost 4, power 2500 in both attack and defense, and `setcode=1` for Light
Bringer. Its host `race` field is zero. Holy Awe (`24001006`) is type `0x3`, cost
6, civilization `0x10`, and has no creature power.

Four records (`24000001`–`24000004`) are nonplayable race-name/text references.
Their unusual `0x4000` type is not a creature template. The rules card
`24000000` is also support infrastructure, not one of the 40 playable cards.
Do not remove these records because they do not look like ordinary cards.

### Card types and markers

| Value | Host bits | DM use |
| --- | --- | --- |
| `0x21` | Monster + Effect | Creature |
| `0x1021` | Monster + Effect + Tuner | Creature with no abilities |
| `0x2000021` | Monster + Effect + Special Summon | Evolution creature |
| `0x3` | Monster + Spell | Spell |
| `0x800` | Gemini/Dual marker | Additive multicolored marker; not a complete type by itself |

The databases contain combined forms such as `0x821` (multicolored
creature), `0x803` (multicolored spell), `0x1821` (multicolored creature without
abilities), and `0x2000821` (multicolored evolution creature). The named constants
are `DM_TYPE_CREATURE=TYPE_EFFECT`, `DM_TYPE_MULTICOLORED=TYPE_DUAL`,
`DM_TYPE_NO_ABILITY=TYPE_TUNER`, and `DM_TYPE_EVOLUTION=TYPE_SPSUMMON`.
These are tests/markers; the complete database type includes the other required
bits shown above.

### Civilizations

| Value | Host attribute | DM civilization | Constant |
| --- | --- | --- | --- |
| `0x1` | EARTH | Nature | `DM_CIVILIZATION_NATURE` |
| `0x2` | WATER | Water | `DM_CIVILIZATION_WATER` |
| `0x4` | FIRE | Fire | `DM_CIVILIZATION_FIRE` |
| `0x10` | LIGHT | Light | `DM_CIVILIZATION_LIGHT` |
| `0x20` | DARK | Darkness | `DM_CIVILIZATION_DARKNESS` |
| `0x0` | No attribute bits | No civilization | `DM_CIVILIZATION_NONE` |

Combine the actual civilization bits for a multicolored card and retain its
multicolored type marker. Constants include named combinations such as
`DM_CIVILIZATIONS_LW` and `DM_CIVILIZATIONS_DFN`.
`DM_CIVILIZATION_ALL` combines the five mapped civilizations. A zero attribute
mask represents no civilization; setting it does not implement additional
mechanics associated with a particular no-civilization card.

### OT: region/source classification

| Value | Catalog meaning |
| --- | --- |
| `0x1` | OCG-only card |
| `0x2` | TCG-only card |
| `0x3` | OCG + TCG card |
| `0x4` | Game-original/custom classification |

These values classify card records. They do not select a rules version, prove
tournament legality, or substitute for a dated restriction list. The current main database also has `ot=0` support/reference records;
`cards-dm-go.cdb` includes an `ot=1` record, so the filename alone is not a region
classification oracle.

## Zones, tapping, and physical cards

| Host location | Value | Adapter meaning | Required distinction |
| --- | --- | --- | --- |
| Monster Zone | `0x4` | Battle zone | Creature position tracks tapped/untapped state |
| Spell & Trap Zone | `0x8` | Shields | Only physical sequences 0–4 pass `Card.IsShield` |
| Graveyard | `0x10` | Untapped mana | The helper recognizes face-up state |
| Banished | `0x20` | Tapped mana | Face-down state |
| Banished | `0x20` | DM graveyard | Face-up state |
| Extra Deck | `0x40` | Hyperspatial-zone encoding | Check the relevant card/procedure before treating a mechanic as supported |

`DM_LOCATION_MZONE` is **Graveyard + Banished**, not the host Monster Zone.
Use `Card.IsMana()` to filter it. `DM_LOCATION_GRAVE` is Banished, but
`Card.IsGrave()` also requires face-up state. Checking location alone can mix
mana with the DM graveyard.

Battle-zone creatures are untapped in Attack Position and tapped in Defense
Position. `POS_FACEUP_UNTAPPED` and `POS_FACEUP_TAPPED` name those mappings.
For mana, tap/untap moves between two host locations; it is not merely an image
rotation. A display color is not authoritative state; use the zone and position
predicates when selecting cards or applying rules.

Use the DM helpers for movement, destruction, mana, and shields. In particular,
`Duel.SendtoSZone` owns shield placement, including evolution-source handling.
It now uses an explicit legal physical slot rather than exposing a hidden card
through a placement prompt. `Duel.BreakShield` owns breaking, breaker choices,
and the associated events. A shield break is not interchangeable with an
arbitrary `Duel.Destroy` call.

The rules card occupies field slot 5, outside the five shield slots. Enlarging a
visual row does not enlarge those core locations. More shields or a different
battle-zone capacity requires a complete core/query/selection/replay design.
Likewise, public DM mana cannot be made public merely by showing the identity of
an arbitrary face-down banished card. See [integration](mdpro4-integration.md)
and the [visibility audit](rules-audit.md#shield-usability-and-privacy).

### Turn phases

An event and a phase are different kinds of engine value: do not pass
`EVENT_PREDRAW` as a phase mask.

| Order | Host event/phase | DM step | Adapter purpose |
| --- | --- | --- | --- |
| 1 | `EVENT_PREDRAW` | Start of Turn / Untap Step | Untap eligible tapped creatures and mana; `DM_EVENT_UNTAP_STEP` aliases this event |
| 2 | `PHASE_DRAW` | Draw Step | Normal turn draw, subject to first-turn and card rules |
| 3 | `PHASE_STANDBY` | Charge Step | Optional hand-to-mana charge |
| 4 | `PHASE_MAIN1` | Main Step | Pay costs and play cards using their implemented procedures |
| 5 | `PHASE_BATTLE` | Attack Step | Attacks and supported tap abilities |
| 6 | `PHASE_END` | End Step | End-of-turn abilities and cleanup |

A step mapping does not provide a procedure for every card type. Check an
implemented card and its helper before adding a new mechanic. Attack-declaration
tapping remains a documented adapter limitation; do not treat its damage-step
workaround as the paper rule.

## Card-search category bits

`datas.category` contains descriptive flags used to index cards. A record may
combine several bits. Setting a flag does not implement an ability or change
its timing. The table gives the current catalog's meanings; bits marked unused
occur in none of the three current card databases.

| Bit | Host category identifier | DM catalog meaning |
| --- | --- | --- |
| `0x1` | Destroy Spell/Trap | Decrease the opponent's shields; Breaker |
| `0x2` | Destroy Monster | Destroy a creature |
| `0x4` | Banish Card | Put a card into the graveyard; discard from a player's hand |
| `0x8` | Send to Graveyard | Put a card into the mana zone |
| `0x10` | Return to Hand | Return from battle, shields, mana, or graveyard to a player's hand |
| `0x20` | Return to Deck | Put a card into a player's deck |
| `0x40` | Destroy Hand | Decrease the opponent's hand size |
| `0x80` | Destroy Deck | Decrease the opponent's deck size |
| `0x100` | Increase Draw | Draw a card from the deck |
| `0x200` | Search Deck | Look at a player's deck |
| `0x400` | GY to Hand/Field | Unused by the current DM catalog |
| `0x800` | Change Battle Position | Untap or tap a card |
| `0x1000` | Get Control | Increase or decrease the cost required to play a card |
| `0x2000` | Increase/Decrease ATK/DEF | Increase or decrease a creature's power |
| `0x4000` | Piercing | No summoning sickness |
| `0x8000` | Attack Multiple Times | Can attack untapped creatures |
| `0x10000` | Limit Attack | Prevent an attack or change its target |
| `0x20000` | Direct Attack | Must attack if able; force a creature to battle another creature |
| `0x40000` | Special Summon | Creature with Shield Trigger; put a card into the battle zone |
| `0x80000` | Token | Unused by the current DM catalog |
| `0x100000` | Type-related | Mentions a race or races in the card's text |
| `0x200000` | Attribute-related | Mentions civilizations in the card's text |
| `0x400000` | Reduce LP | Decrease the opponent's mana-zone card count |
| `0x800000` | Increase LP | Increase the number of shields |
| `0x1000000` | Cannot Be Destroyed | Prevent a card from being destroyed |
| `0x2000000` | Cannot Be Targeted | Prevent a creature from being blocked or chosen by an ability |
| `0x4000000` | Counter | Prevent the opponent from casting spells |
| `0x8000000` | Gamble | Unused by the current DM catalog |
| `0x10000000` | Fusion | Unused by the current DM catalog |
| `0x20000000` | Synchro | Unused by the current DM catalog |
| `0x40000000` | Xyz | Evolution creature, evolution text, or evolution-source interaction |
| `0x80000000` | Negate Effect | Unused by the current DM catalog |

**Do not confuse this table with `Effect.SetCategory`.** The shared helper also
uses runtime effect categories: `DM_CATEGORY_BLOCKER=0x10000000` and
`DM_CATEGORY_SHIELD_TRIGGER=0x800`. Those values have a different purpose from
the CDB metadata above. For instance, the CDB currently leaves the Fusion bit
unused, while a runtime blocker effect deliberately uses that same numeric bit.
Keep the database field and effect API separate.

## Finding definitions and matching data

Search by printed name, card ID, or the semantic helper involved:

```powershell
rg -n "Chilias|Holy Awe" expansions/script
rg -n "DM_EFFECT_BLOCKER|DM_HINTMSG_BREAK" expansions
rg -n "function Auxiliary.EnableCreatureAttribute" expansions/utility_dmtcg.lua
```

For database inspection, join `datas` and `texts` on `id`. Filter `type` for
creature/evolution/multicolored markers, `attribute` for civilization, `level`
for printed mana cost, `atk` for printed power, `setcode` for race membership,
and `ot` for region classification. These are storage fields; a script's current
cost or power can differ after effects apply.

For example, this read-only query inspects one definition without relying on
a particular client search menu:

```sql
SELECT d.id, t.name, d.type, d.attribute, d.level, d.atk, d.def,
       d.setcode, d.ot, d.category
FROM datas AS d
JOIN texts AS t ON t.id = d.id
WHERE d.id = 24001001;
```

SQLite inspection should use a read-only connection and close it explicitly.
Never diagnose a database by opening it in a way that creates a journal alongside
a running application's file. Do not edit the excluded DataEditorX folder merely
to change a card script.

## Writing a card script

Start from a card with the same procedure. A minimal creature has this current
header and registration shape:

```lua
--Printed card name
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()

function scard.initial_effect(c)
    dm.EnableCreatureAttribute(c)
    --Register this card's supported abilities here.
end

scard.duel_masters_card=true
```

Save it as `expansions/script/c<id>.lua` and create matching CDB rows. This example
is a registration skeleton, not a complete implementation of any printed card.
Do not publish a skeleton as though its abilities were implemented.

The script marker `scard.duel_masters_card=true` is used by startup's DM-membership
check. `sid` identifies the card definition, not a unique physical copy in a duel.
For delayed effects, keep the actual handler/target and its required controller,
zone, relation, and reset rules; another copy with the same card ID is not a
replacement for the original target.

The helper's `dm.GetID()` delegates to the deployed core's `GetID()` and asserts
that identity is available. Do not restore `debug.getinfo` filename inspection
or filesystem `require`. The deployed sandbox lacks `require` and `debug`, and
archive scripts must load through the host callback.

### Existing examples worth following

| Example | Useful pattern |
| --- | --- |
| [Chilias, the Oracle](../expansions/script/c24001001.lua) | Creature registration and a destruction-replacement return-to-hand effect |
| [Holy Awe](../expansions/script/c24001006.lua) | Spell registration, Shield Trigger, and a tap operation |
| [Crystal Lancer](../expansions/script/c24002015.lua) | Evolution procedure, race filtering, unblockability, and Double Breaker |

Holy Awe's relevant initialization is:

```lua
function scard.initial_effect(c)
    dm.EnableSpellAttribute(c)
    dm.EnableShieldTrigger(c)
    dm.AddSpellCastEffect(c,0,nil,
        dm.TapOperation(nil,Card.IsFaceup,0,DM_LOCATION_BZONE))
end
```

Crystal Lancer registers an evolution procedure with
`aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_LIQUID_PEOPLE)` and records
`scard.evolution_race_list={DM_RACE_LIQUID_PEOPLE}`. Reuse the matching procedure;
adding an evolution type bit alone does not handle materials, payment, inherited
position, or evolution sources.

Useful semantic aliases include:

| Helper | Reads/represents |
| --- | --- |
| `Card.GetManaCost` | Printed cost (`GetOriginalLevel`) |
| `Card.GetPlayCost` | Current cost (`GetLevel`) |
| `Card.GetCivilization` | Current civilization mask (`GetAttribute`) |
| `Card.DMIsRace` | Race membership via set codes |
| `Card.GetPower` | Current power (`GetAttack`) |
| `Card.GetSourceGroup` | Evolution sources (`GetOverlayGroup`) |
| `Card.GetSourceCount` | Number of evolution sources |
| `Card.IsShield` | S/T location and shield sequence |
| `Card.IsMana`, `Card.IsGrave` | Location plus the adapter's position distinction |
| `Card.IsTapped`, `Card.IsUntapped` | Zone-sensitive tapped state |

### Description IDs and prompts

Use existing `DM_HINTMSG_*`, `DM_QHINTMSG_*`, `DM_DESC_*`, and `DM_DECKERROR_*`
constants for shared DM wording. Their literal system IDs occupy the reserved
8000–9999 interval; this fork currently supplies 50 definitions.
`expansions/mdpro4-dm-strings.conf` must change with any new shared prompt.

Card-specific strings use `aux.Stringid(sid,index)`, where index 0 corresponds
to `texts.str1`, index 1 to `texts.str2`, and so on through the host's sixteen
string slots. Do not use string indexes as printed-paragraph identity.
MDPro4 interprets a description below 10000 as a system string, and a larger
value as `(card ID << 4) | index`. An arbitrary large `!system` number will
therefore not work as a separate namespace.

Victory reasons occupy a different region and are byte-sized. The pack uses
DM reasons `0x4d`–`0x4f`; do not renumber them into the system-prompt range.
The DM prompt configuration does not replace the host's global translations or
phase labels. Session-specific UI terminology belongs to the host integration.

## Helper, group, and asset lifetimes

The `MDPro4DM` and `MDPro4DMConstants` tables belong to one duel's Lua state.
Guarded initialization prevents stacking the adapter's wrappers every time
another card script loads. Although the package has unique helper filenames,
it still adapts `Card`, `Group`, and `Duel` APIs inside that duel; it is not a
pure library that can be loaded globally into unrelated games without effects.
Do not override the host's base utility archive or add a startup hook that turns
on DM behavior in every duel.

Use the core's seeded random generator for randomized game decisions. A
wall-clock seed or `os` module can make equivalent runs diverge and undermine
replay reproducibility. A repeatable RNG smoke test is narrower than a saved
replay round trip; run the latter when changing replay-visible behavior.

Native `Group` iteration has its own lifetime. Collect evolution sources before
mutating the group being iterated: `dm.IncludeEvolutionSources` exists because
even merging an empty group invalidates the core's `GetFirst`/`GetNext` iterator.
When a group must survive between callbacks, follow the helper's `KeepAlive()`
pattern and release that retained group with `DeleteGroup()` when the owning
operation is finished. For example, the evolution target stores a retained group
on the effect; `EvolutionOperation1` consumes and deletes it. Changes that add
cancellation or replacement paths must account for that retained group too.
A borrowed group is not automatically owned by the caller.

Artwork does not belong to a Lua card script. The YPK supplies bytes and metadata;
MDPro4 owns archive handles, decoded textures, cached card images, and materials.
A view borrows a cache lease and balances the corresponding release. Do not
unload a shared archive or destroy a shared material to refresh one card. The
[source-to-view ownership trace](mdpro4-integration.md#resource-lifetimes)
documents those host boundaries.

## Artwork and IDs

The supplied DM-01 images are complete printed cards. Keep them as `full_card`
inputs and package them under `pics/<id>.jpg`. Isolated JPG illustrations use
`art/<id>.jpg`; isolated PNG illustrations use `art2/<id>.png`.
The inventory requires that image kind explicitly and does not crop a scan.

Automatic identity accepts an exact numeric ID or a unique exact normalized card
name. UUID filenames, a similar name, and directory order are not evidence.
For an explicit mapping, add the relative source path, target card ID, expected
SHA-256, and image kind to `config/artwork-map.json`. The tool rejects changed
reviewed inputs and paths outside the supplied source root. A PNG/WebP scan
requires real JPEG encoding for the host's `pics/` route, not an extension rename.

Do not change card IDs to match a convenient image filename. Existing decks,
script references, aliases, custom event identifiers, descriptions, and replays
may depend on those IDs. Check host CDB collisions before adding new definitions.
Display support and card-game support remain separate acceptance scopes.

## Validation workflow

Run commands from the repository root. Python 3.11 or later is required; image
conversion additionally needs Pillow. The standalone Lua runner requires an
explicit installed Lua 5.3/5.4 executable or compatible shared library.

```powershell
# Catalog, packaging, artwork, and prompt contracts.
python -m unittest discover -s tests -p "test_*.py"

# Bounded rule regressions; requires lua on PATH.
python tools/run_lua_tests.py --lua lua

# Build the ordinary YPK and reject collisions with the intended host catalog.
python tools/build_package.py --host-cdb "D:/Programs/GitHub/MDPro_3/Data/locales/en-US/cards.cdb"
```

For source artwork:

```powershell
python tools/artwork.py --artwork-root "G:/Modding/Duel Masters/DM Sets" --map config/artwork-map.json --image-kind full_card --output build/artwork-manifest.json
python tools/build_package.py --artwork-manifest build/artwork-manifest.json --host-cdb "D:/Programs/GitHub/MDPro_3/Data/locales/en-US/cards.cdb"
```

Validate against the deployed core, not just a sibling source checkout:

```powershell
python tools/core_smoke.py --core "D:/Programs/GitHub/MDPro_3/Assets/Plugins/Windows/ocgcore.dll" --host-scripts "D:/Programs/GitHub/MDPro_3/Data/script.zip" --package dist/MDPro4-Duel-Masters.ypk --report build/core-smoke.json
```

Only use a binary whose ABI matches this host's `create_duel` / reader callbacks.
The smoke test does not operate the connected Editor. It covers packaged card
loading/initialization, helper lifetime, seeded RNG, and opening response flow;
it is not proof that every card effect resolves correctly.

For a rules change, add a bounded regression with a clear trigger and expected
state. For movement/selection changes, also inspect real core messages, response
pauses and authoritative queries. For asset changes, inspect both deck and duel
rendering and verify cancellation/reload cleanup. For replay-state changes,
generate a replay and reload it. Keep those claims separate in the acceptance
record, preserve failure evidence, and commit completed categories locally.

## Terminology in code

Use DM terminology when naming helpers and documenting card behavior. The
engine vocabulary below explains the current implementation; it is not a
substitute for checking a card's actual operation and timing.

| DM term | Current adapter meaning |
| --- | --- |
| Ability | Effect |
| Active Player | Turn player |
| Attack Step | Battle Phase |
| Attack Trigger | Effect associated with a creature's attack |
| Break | `Duel.BreakShield` and its shield movement, breaker selection, and events |
| Cast | Spell procedure from hand with mana payment and applicable trigger rules |
| Charge Mana | Optional hand-to-mana action during the charge step |
| Charge Step | Standby Phase |
| Choose | Select a card/target as specified by the DM helper; not a blanket import of every YGO targeting rule |
| Civilization | Attribute mask |
| Come Into Play | Battle-zone entry, commonly mapped through Special Summon success |
| Creature | Monster encoding |
| Defending Player | Non-turn player in the ordinary attack flow |
| Discard | DM discard helper, which moves the card from hand to the encoded DM graveyard |
| Draw Step | Draw Phase |
| End Step | End Phase |
| Leave | Leave the battle zone / host field, with zone and source handling |
| Look | Inspect information that is otherwise hidden, only when authorized by the effect |
| Main Step | Main Phase 1 |
| Mana | Host graveyard or face-down banished cards, filtered by `IsMana` |
| Monocolored | One civilization |
| Multicolored | Two or more civilizations, including the adapter's marker/rules |
| Power | Attack/defense database values; current power uses attack |
| Put Into Graveyard | DM graveyard movement, encoded as face-up banishment |
| Race / Category | DM set-code membership, not the host `race` column |
| Reveal | Make a card's identity public according to the effect |
| Search | Look through a player's deck according to the effect |
| Shield | S/T-zone card in a shield slot |
| Static Ability | Continuous-effect machinery |
| Step | Phase/event mapping |
| Summon | Creature procedure with mana payment, encoded through Special Summon |
| Summoning Sickness | Restriction associated with entering the battle zone that turn, subject to supported exceptions |
| Switch | Exchange cards between the specified zones using the appropriate helper |
| Tap | Defense Position for a creature; face-down banishment for mana |
| Tapped | Zone-sensitive state, not a universal face-down test |
| Trigger Ability | Trigger-effect machinery |
| Untap | Attack Position for a creature; return tapped mana to the host graveyard |
| Untap Step | Predraw event / start-of-turn handling |
| Untapped | Attack Position for a creature or face-up untapped mana |
| Up to | Zero through the permitted maximum; zero is a real choice |

When a term's intended rules meaning and the implementation differ, trace the
responsible helper and authoritative state. Document the gap, add a focused
regression, and change the owning procedure together with its affected callers.
