# MDPro4 runtime compatibility

The package uses the deployed MDPro4 native core, its standard `script.zip`, and
its normal `.ypk` script loader. The archive does not replace the host's
`constant.lua`, `utility.lua`, or `procedure.lua`.

## Script ownership

- `expansions/utility_dmtcg.lua` packages as `script/dm/utility.lua`.
- `expansions/constant_dmtcg.lua` packages as `script/dm/constants.lua`.
- Each card loads the helper through `Duel.LoadScript("dm/utility.lua")` only
  when `MDPro4DM` is absent. The helper publishes that table after initialization.
- `MDPro4DMConstants` prevents duplicate constant initialization. Reloading the
  helper preserves its table and wrapped host-function identities.
- Both tables belong to the native duel's Lua state and disappear with that
  duel. There is no process-wide cache or Unity texture/material ownership here.
- Card identity comes from host `GetID()`. The helper no longer requires Lua's
  unavailable filesystem `require` or `debug.getinfo` libraries.
- Legacy userdata classification is local to the helper. Global Lua `type()`
  retains the host implementation. Existing Duel/Card/Group compatibility
  wrappers still intentionally apply within a Duel Masters duel; mixing game
  systems in one duel is unsupported and rejected by the rules card.
- Hand, deck, and grave movement collect evolution sources before merging into
  the selected Group. Merging even an empty source Group during native iteration
  invalidated `GetNext` and previously aborted normal five-card host startup.
- Three game-original random outcomes use `Duel.GetRandomNumber`, including
  Terradragon Hulcoon Berga. They no longer reseed a separate generator from the
  wall clock. The actual native core owns seed lifetime.

The inspected sibling `ygopro-core` checkout does not expose the same API as the
installed binary. Its source alone is insufficient evidence for runtime support.
The native smoke test fails clearly unless the supplied core provides the
required loading and random-number functions.

## Native acceptance on 7 November 2026

Command (supply paths for the intended MDPro4 installation):

```powershell
python tools/core_smoke.py --core <ocgcore.dll> --host-scripts <script.zip> --package <MDPro4-Duel-Masters.ypk> --report <report.json>
```

Omit `--package` to validate the source-to-archive mappings. The harness opens
CDBs read-only, pins callback buffers until `end_duel`, closes ZIP handles, and
does not use or modify a connected Editor or live player's duel.

The source fixture passed against native core SHA-256
`51287007cb534e89443e3990c6e97629a163b36165f5443ed8d23f72173d47cc`
and host scripts SHA-256
`7638c79ebcc7fbfa03980a3cf32375558d2633fd053de2b8f8c2ecff372885cb`:

- 1,017 playable CDB cards initialized, using 1,006 canonical card scripts and
  eleven aliases. Four token-type Race List reference records (24000001 through
  24000004) have no gameplay script and are explicitly excluded from spawning.
- No native Lua diagnostics; global `type()` preserved; repeated helper loads
  did not wrap the same host function twice; helper state did not leak into a
  newly created duel.
- The same native seed produced the same 32-value random sequence; a different
  seed changed the sequence.
- A real opening with 40 cards plus the support card on each side produced five
  facedown shields, five cards in hand, and 30 cards in deck. The support card
  occupied the field slot. This passed both with normal host defaults (five
  opening cards, one draw per turn) and with an isolated zero-host-draw setup.
  The rules return the host opening hand to the deck before dealing shields.
- The core emitted no shield identity selection hint and no placement request.
  The legitimate optional mana selection received a zero-card response; two
  empty optional chain windows received pass responses; processing continued to
  the first idle command. The normal-host fixture parsed 40 packets and the
  isolated fixture parsed 28, using checked message widths.

This does not certify every card effect, a complete game, or saved-and-reloaded
replay playback. The remaining ocgcore zone-capacity and attack timing
adaptations are recorded in the rules audit. Do not describe native script
initialization or an opening fixture as full Duel Masters rules conformance.
