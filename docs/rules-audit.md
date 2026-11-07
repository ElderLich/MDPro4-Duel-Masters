# Duel Masters rules audit

Inspected 7 November 2026. This is a bounded audit of the imported YGOPro-DM
adapter, not a certification of every card or the complete current game.

## Rules baseline and source priority

The maintained Japanese paper game uses Takara Tomy's [Comprehensive Rules
v1.54, 6 November 2026](https://dm.takaratomy.co.jp/img/dm_rule_20261106.pdf),
linked from the [official rules index](https://dm.takaratomy.co.jp/rule/rulechange/).
Rules 100.2/100.2a specify exactly 40 cards and normally at most four copies of a
name. Rules 506.1c and 703.4b cover tapping during attack declaration and losing
when the deck is empty. Shield triggers and their resolution priorities are
covered by 101.4; public mana information by 405.2.

The requested [Fandom Rule page](https://duelmasters.fandom.com/wiki/Rule) was
unavailable through the reader. Its [General Game Rules page](https://duelmasters.fandom.com/wiki/General_Game_Rules)
is useful navigation and translation, but the inspected page still identifies
v1.49. It also distinguishes the historical English format's deck-size rule and
optional adoption of later Japanese revisions. Do not silently treat historical
English TCG, modern Japanese paper play, and Duel Masters PLAY'S as identical.

For this first port the existing catalog and its documented 40-card setup are
retained. The result is a **legacy mapped rules mode**, not a complete 2026 paper
rules engine. A future format selector needs explicit card-pool, restriction-list
date and rules-version definitions. The imported `lflist.conf` is historical,
not a verified current Hall of Fame list. Dated set-catalog decks are not
necessarily playable; two starter variants also contain side cards. All 17
starter main decks contain 40 playable cards plus the rules card. Preserve those
reference sources and package only starters that pass explicit deck validation.

## Corrected deterministic defects

| Owner | Trigger and previous behavior | Correction / evidence |
| --- | --- | --- |
| `expansions/script/c24000000.lua`, startup | A deck with over 40 playable cards passed despite the existing error text and README requiring exactly 40. | Require exactly 40 after removing the bootstrap rule card and returning the initial hand. Matches the [official basic deck rules](https://dm.takaratomy.co.jp/rule/basic/basic08/). |
| Same startup | One player had a size violation and the other had a non-DM card. The combined invalidity test could award a win to an invalid deck. | Combine each player's reasons first; both invalid players produce the existing invalid-duel result. This is adapter validation policy, not an invented tournament penalty. |
| `expansions/utility_dmtcg.lua`, `Duel.BreakShield` | With Triple and Crew Breaker but no Double Breaker, the first offered choice dispatched Double Breaker; other sparse combinations could likewise dispatch the wrong ability. | Translate the selected menu index through the same filtered ability list used to render it. |
| `expansions/utility_dmtcg.lua`, movement helpers | Returning the initial hand to the deck merged evolution sources into the Group while its native iterator was active; even an empty merge invalidated iteration. | Collect permitted sources in a separate Group, then merge after iteration. Native host-default startup and six bounded regressions cover the correction. |

## Shield usability and privacy

Shield placement now selects the first available physical S/T slot (0 through 4)
inside the Lua producer. It passes a single-bit zone mask to `Duel.MoveToField`.
The rule card is explicitly placed in field slot 5. Existing shields keep their
positions; filling a hole does not reorder them. This applies to opening setup
and later shield additions, without asking the player to enable auto placement.

The checked-out core's `libduel.cpp` accepts the mask as argument 7;
`operations.cpp` bypasses both the identity-bearing `HINT_SELECTMSG` and
`SELECT_PLACE` when that mask has one bit. The deployed MDPro4 DLL is validated
separately because it differs from the sibling source checkout.

The next host interaction should present stable, numbered card backs for shield
choices, with one confirmation for a multi-break and one clear trigger decision
per declared trigger. A hidden shield must never supply its name, art, tooltip,
preview or searchable identity to either player's ordinary inspection UI. Reveals
must be driven by authoritative effects and expire at the correct boundary.

This requires host/network work: the sibling core's `playerop.cpp` writes offered
codes into `MSG_SELECT_CARD`. The adapter randomizes selection of the chooser's
own shields, but delegates opponent-shield choices to the core. Inspect the
deployed server's redaction and replay serialization before claiming secrecy.
Do not remove that legacy random-selection workaround on presentation evidence
alone. Record live movement, response and replay acceptance separately.

## Remaining adapter limits

| Area | Observed implementation | Required acceptance before a broader claim |
| --- | --- | --- |
| Board capacity | `Card.IsShield` recognizes only five S/T slots. The imported README documents a six-creature maximum. | A coherent core/query/view design for larger zones, including physical identity and selection. A `.ypk` alone does not expand fixed engine zones. |
| Attack tapping | Rules-card comment explicitly says incomplete; `tapop` runs at damage-step end, with extra taps in shield breaking. | Real attack-declaration, cancelled attack, blocker and untap-during-attack fixtures before replacing the workaround. |
| Mana visibility | Tapped mana is face-down banished state; upstream warns that opponents cannot inspect some cards placed from private zones. | Public mana identity must come from authoritative state without revealing genuine hidden zones. |
| Shield secrecy | Shield selection contains random-selection workarounds because YGOPro exposes the owner's face-down cards. | Inspect both players' UI, network queries and saved replay; a display-only hide is insufficient. |
| Shield triggers | Breaks move groups and raise per-card custom events over Yu-Gi-Oh chain handling. | Simultaneous break, several declarations, creature entry triggers and nested breaks against the selected rules version. |
| Deck legality | Startup checks size and DM membership; imported format lists contain legacy counts. | Same-name aliases, four-copy limits, explicit exceptions, format legality and dated restrictions need end-to-end deck validation. |
| Deck-out | `winop` observes empty decks at `EVENT_ADJUST`. | Last-card draw, milling, interrupted effects and loss-prevention cards need actual core timing fixtures. Merely looking at deck cards must not change membership. |
| Card coverage | `BreakShield` explicitly lacks multiple modern breaker families; catalog scripts encode old card behavior. | Audit each implemented family and each affected card. Do not extrapolate coverage from successful script loading. |

## Validation

`tests/rules_regression.lua` executes the actual startup function for 72
combinations of 39/40/41-card decks, foreign-card presence and initiating player.
It also executes the actual complete `BreakShield` function up to selection for
13 combinations of breaker availability and choice, and the real placement
helper for all 32 unavailable-slot masks for both players. Six evolution-group
cases cover empty, single, multiple, protected, shared and already-selected
sources, with a Group mock that invalidates iteration even when merging an empty
group. Core services are bounded
stubs; these checks prove startup decisions and menu dispatch, not movement,
response pausing, rendering, resource lifetimes or replay playback.

Run from any directory with Lua 5.3/5.4 installed:

```text
python tools/run_lua_tests.py --lua lua
```

An existing trusted Lua 5.3/5.4 DLL can be supplied explicitly with `--lua-dll`.
The runner bundles no third-party runtime and gives each test a fresh process and
30-second deadline. All 155 regressions passed using an existing Lua DLL; all 1,021 expansion Lua
files also syntax-compiled.
Isolated scratch variants restoring each of the three original rules defects
failed the corresponding tests. A fourth scratch variant restoring in-loop Group
merging failed specifically on iterator invalidation. Record real core, Unity and replay evidence
separately; these tests do not substitute for it.

A separate deployed-core fixture passed with SHA-256
`51287007cb534e89443e3990c6e97629a163b36165f5443ed8d23f72173d47cc`.
Both players reached deck 30, hand 5 and five face-down shields in slots 0–4,
with the rule card in slot 5. It observed zero placement requests and zero
card-identity selection hints during setup. The fixture answered the optional
mana charge and two empty chain windows and reached the idle-command offer.
The isolated fixture used core initial-hand and draw-per-turn settings of zero.
A second fixture with normal host settings (five initial cards and one turn draw)
also passed after fixing native Group iterator invalidation in movement helpers.
Neither fixture certifies subsequent turn draws, full battle flow or saved replay playback. The compact
runtime audit owns the full acceptance record; transient packet details stay
outside the repository.
