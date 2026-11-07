# MDPro4-Duel Masters

Preserve the upstream baseline tag, GPL license and original-author attribution.
Do not edit the sibling ygopro-dm source repository. Textures and DataEditorX are
out of scope. Original game scans remain external inputs with reviewed mappings.

Use the actual deployed MDPro4 core to establish API compatibility; an older core
source checkout is insufficient evidence. Shared helpers live in source under
expansions and package under script/dm. Never package global stock utility or
constant replacements, or globally rewrite the host's translations for DM.

Keep hidden shields hidden through setup, movement, selection, replay and display.
Fix decisions in the Lua/core owner when possible. Host UI may describe available
choices but must not infer authoritative state or fabricate extra engine zones.

Run package/unit checks and the scoped native/Lua harness for changed behavior.
Report source, script initialization, actual duel flow, replay and visual QA as
separate results. Commit each coherent change separately with a descriptive subject and body
covering the reason and validation. Commit locally; do not push without request.
Do not claim all card effects or current Japanese mechanics are complete from
loader-only checks. The maintained first target is the inherited card pool.
