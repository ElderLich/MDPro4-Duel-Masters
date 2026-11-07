# Native full-duel and replay QA

`tools/full_duel_qa.py` plays complete games against the explicitly supplied
MDPro4 native core. It answers actual offered choices, records the seed, decks
and responses in standard `.yrp` files, reads those files back from disk, and
replays their responses through a fresh native duel. Every native packet and
response must match the first run. No fixture injects card state or a winner.

Run it from the repository with Python 3.11 or newer. Use a new output directory
for each run; the tool refuses to overwrite previous evidence.

```powershell
python -B tools/full_duel_qa.py `
  --core "D:\Programs\GitHub\MDPro_3\Assets\Plugins\Windows\ocgcore.dll" `
  --host-scripts "D:\Programs\GitHub\MDPro_3\Data\script.zip" `
  --package build/integration-candidate.ypk `
  --output-dir build/qa/full-duel-run-1
```

Omit `--package` to test source scripts. Packaged runs additionally require exact
source/YPK database and helper matches, since the native card reader uses the
source SQLite records. `--scenario NAME` selects a case and can be repeated.
This tool does not modify an Editor, player settings, the installed package or
the supplied core. Generated replays and raw failure details are QA artifacts,
not a player-facing hidden-card log.

## Acceptance cases

Each player uses forty ordinary cards: four copies of ten distinct names. One
engine-only rules support card is added outside that forty-card pool. The
strategy chooses its own playable cards, prefers low costs, charges mana, summons
creatures and attacks. It selects facedown shields by offered index, never by
their identities. The double-breaker case prioritizes the player's own available
Radioactive Horn, Strange to exercise that ability.

| Case | Required actual outcome |
| --- | --- |
| `shield-trigger-accept` | A broken shield offers a creature trigger, the player accepts, and that creature is summoned during resolution. |
| `shield-trigger-decline` | The same seeded game offers an optional creature trigger, the player declines, and it never activates. |
| `spell-shield-trigger` | Tornado Flame is cast during the opponent's turn and destroys a creature during its Shield Trigger resolution. |
| `double-breaker` | The core requests at least two shields in one break selection; actual shields move to hand. |
| `full-battle-zone-trigger` | A creature trigger shield breaks while all five supported creature slots are occupied, and the duel still reaches its normal win. |

All cases require both five-shield openings, actual mana charges, summons,
attacks, shield movement and a normal attack win after the defender has no
shields. A native retry, unsupported/truncated packet, Lua diagnostic, unused
saved response, divergent replay, 10,000 processing steps or a 45-second native
loop deadline fails the run. Callback buffers stay alive until `end_duel`; each
duel and archive is released when its owner finishes.

## Replay contract

The generated file uses the host's existing uncompressed YRP1 format: 32-byte
header, two names of twenty UTF-16 code units, four 32-bit duel settings, counted
main/extra decks, then one-byte-length response records. The settings are 8000
host LP, five initial cards, one host draw and `5 << 16` options. The DM rules
script supplies the game rules. YRP stores the pre-MersenneTwister seed;
`CoreWrapper.BuildYRP3dBuffer` and this tool pass the first MT output to
`create_duel`.

The exercised packet grammar follows the actual deployed core and
`CoreWrapper.Analyse`: chain offers have fourteen-byte entries, with a forced
flag per entry; the chain header's third byte is `spcount`, not a forced flag.
`ConfirmCards` includes `recipient`, `skip_panel`, then a counted card list.
Older transport parsers must not be used to infer this native replay ABI.

## Verified result — 7 November 2026

The five cases passed against Windows core SHA-256
`51287007cb534e89443e3990c6e97629a163b36165f5443ed8d23f72173d47cc`,
host scripts SHA-256
`7638c79ebcc7fbfa03980a3cf32375558d2633fd053de2b8f8c2ecff372885cb`
and candidate YPK SHA-256
`76536e7b2a673d241129fa7c259695b236960904416f2bf7a7a5483012fe9c3a`.
Every game ended on turn nine with no Lua diagnostics; all five disk-loaded
replays reproduced their entire native event streams exactly. This hash
identifies the gameplay-tested integration candidate; the final versioned
release asset has its own authoritative `.sha256` sidecar.

The accepted creature case resolved one trigger summon. The declined case
offered one trigger and activated none. The spell case resolved two Tornado
Flame triggers destroying two creatures. The double-breaker case produced two
multi-shield selections. The full-zone case completed in 283 responses.

A response audit confirmed that acceptance and decline use the same actual
optional `SelectChain` offer: `spcount=1`, per-entry `forced=0`, and the card
already in the receiving player's hand. The accepted response was index zero
and reached summon-success; the declined response was `-1` and did not
activate. Zeroing every card ID in all 39 shield-selection offers left each
decision unchanged. All 45 mana-charge offers contained only the selecting
player's own hand.

The full-zone fixture found a real infinite reoffer: `DMIsSummonable()` alone
did not establish free battle-zone capacity, so a failed trigger summon was
offered again after its chain ended. `ShieldTriggerSummonTarget` now checks
`Duel.GetLocationCount(tp, DM_LOCATION_BZONE) > 0` before offering it. The same
seed that previously exhausted the processing bound now completes normally.

The capacity guard matches the existing effect-summon path; it does not implement
full-field evolution or create native capacity. The collection includes
**Q-tronic Omnistrain (`240039`)**, a game-original evolution creature with
printed Shield Trigger. Its evolution condition accepts a valid Survivor base
at a full field, but the inherited `Duel.SendtoBZone` / `Duel.SpecialSummon`
wrapper checks for an empty slot **before** raising the evolution/base-consumption
event. This limitation predates the guard: the old target could offer a summon
that then failed; the guard now rejects that unavailable operation. The normal
paid `AddEvolutionProcedure` path is separate and was not changed.

**Wolfis, Blue Divine Dragon (`24027`)** can grant Shield Trigger to a broken
shield. Its script performs an `IsAbleToBZone` check and calls `SendtoBZone`
directly, rather than using `ShieldTriggerSummonTarget` for that immediate
summon. The guard does not repair that distinct evolution interaction. A native
predicate check with Q-tronic, one valid Survivor and five occupied slots
confirmed zero free slots, a valid evolution base and a rejected trigger target;
this was a constructed predicate check, not a complete evolution duel.
Full-field evolution through effects/Shield Trigger needs its own authoritative
base-consumption and response/replay tests before it can be claimed supported.

## Host replay and handler checks

The local host integration is maintained on `Duel-Masters` at `e84c3009c`;
that branch has not been pushed and the YPK includes no compiled host update.
Rendering, DM card facts, shield privacy/counts and selection callbacks have
their own bounded checks. The actual native multi-break offer was also fed
to the real host handler on a paused replay: physical slots 1–4 were offered,
physical slots 2 and 3 were selected, and the response was `020102` (offered
indexes 1 and 2). All 28 handler checks passed, including single submission
and state restoration. This does not claim physical pointer input or a
second live native duel. All five saved files subsequently passed through the
actual Unity replay player: three normal-view cases and two Free View cases,
each reaching its turn-nine win, result confirmation and complete exit.
Observed shield privacy and movement-driven HUD counts passed. Views closed,
settings were restored and the final Console had no warnings or errors.
Replay seeking and physical input were not certified. The detailed host
record is in [acceptance.md](acceptance.md).

Native deterministic replay equality is separate from Unity playback, seeking,
replay perspective/privacy, rendering, input and resource-lifetime acceptance.
Open the generated `.yrp` files through MDPro4's normal replay parser/player for
those checks. These five fixtures do not certify every card, blocker/evolution
interaction, multiplayer transport, more than five shields, unrestricted
creature zones, or current Japanese mechanics. Track host acceptance in
[acceptance.md](acceptance.md).
