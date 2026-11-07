-- Bounded behavioral tests of production Lua with core services stubbed.
-- These do not certify ocgcore movement, response handling, or replay playback.
local function read(path)
    local file = assert(io.open(path, "rb"))
    local content = file:read("*a")
    file:close()
    return content:gsub("\r\n", "\n")
end

local passed = 0
local function check(condition, message)
    assert(condition, message)
end

-- Load the real rules card. Its startup calls are bounded before field setup.
local rules = {}
local dm = {GetID = function() return rules, 24000000 end}
package.loaded["expansions.utility_dmtcg"] = dm
MDPro4DM = dm
Duel = {LoadScript = function() return true end}
assert(load(read("expansions/script/c24000000.lua"), "@c24000000.lua"))()
rules.position_rule_card = function() end
rules.shuffle_deck = function() end
LOCATION_DECK, LOCATION_ALL = 1, 255
HINT_MESSAGE, PLAYER_NONE = 1, 2
DM_DECKERROR_DECKCOUNT, DM_DECKERROR_NONDM = 1450, 1451
DM_WIN_REASON_INVALID = 77
local effect = {GetHandler = function() return {} end}
local accepted = {}

for turn = 0, 1 do
    for _, count0 in ipairs({39, 40, 41}) do
        for _, count1 in ipairs({39, 40, 41}) do
            for foreign0 = 0, 1 do
                for foreign1 = 0, 1 do
                    local counts = {[0] = count0, [1] = count1}
                    local foreign = {[0] = foreign0, [1] = foreign1}
                    local winner, reason, started
                    Duel.GetFlagEffect = function() return 0 end
                    Duel.RegisterFlagEffect = function() end
                    Duel.GetFieldGroupCount = function(player) return counts[player] end
                    Duel.GetMatchingGroupCount = function(_, player) return foreign[player] end
                    Duel.Hint = function() end
                    Duel.Win = function(player, why) winner, reason = player, why end
                    Duel.SetLP = function() started = true; error(accepted) end
                    local ok, err = pcall(rules.operation, effect, turn)
                    local invalid0 = count0 ~= 40 or foreign0 > 0
                    local invalid1 = count1 ~= 40 or foreign1 > 0
                    local label = string.format("startup tp=%d size=%d/%d foreign=%d/%d",
                        turn, count0, count1, foreign0, foreign1)
                    if invalid0 or invalid1 then
                        check(ok, label .. ": unexpected Lua error: " .. tostring(err))
                        local expected = invalid0 and invalid1 and PLAYER_NONE or (invalid0 and 1 or 0)
                        check(winner == expected and reason == DM_WIN_REASON_INVALID,
                            label .. ": invalid deck outcome mismatch")
                        check(not started, label .. ": initialized an invalid duel")
                    else
                        check(not ok and err == accepted and started and winner == nil,
                            label .. ": valid decks rejected")
                    end
                    passed = passed + 1
                end
            end
        end
    end
end

-- Load the actual complete BreakShield function, retaining its local dependency
-- name. Stop at shield selection: this test certifies option dispatch only.
local source = read("expansions/utility_dmtcg.lua")
local first = assert(source:find("function Duel.BreakShield(", 1, true))
local last = assert(source:find("\nAuxiliary.break_select_list=", first, true))
Auxiliary = {ShieldZoneFilter = function() return function() return true end end,
    break_select_list = {[1] = 101, [2] = 102, [3] = 103}}
assert(load(source:sub(first, last - 1), "@utility_dmtcg.lua:BreakShield"))()
DM_EFFECT_CHANGE_SHIELD_BREAK_PLAYER = 1
DM_EFFECT_DOUBLE_BREAKER, DM_EFFECT_TRIPLE_BREAKER, DM_EFFECT_CREW_BREAKER = 2, 3, 4
DM_EFFECT_BREAKER, DM_EFFECT_BREAK_EXTRA_SHIELD = 5, 6
DM_LOCATION_SZONE, REASON_RULE, REASON_EFFECT = 8, 1, 2
HINT_SELECTMSG, DM_HINTMSG_APPLYABILITY, DM_HINTMSG_BREAK = 2, 3, 4
Duel.IsPlayerAffectedByEffect = function() return false end
Duel.Tap = function() return 1 end
local selected = {}
local code = 24001001
_G["c" .. code] = {crew_breaker_count = function() return 4 end}

for mask = 0, 7 do
    local choices = {}
    for ability = 1, 3 do
        if math.floor(mask / 2 ^ (ability - 1)) % 2 == 1 then
            choices[#choices + 1] = ability
        end
    end
    for choice = 1, math.max(1, #choices) do
        local expected = choices[choice] and choices[choice] + 1 or 1
        local creature = {
            IsCreature = function() return true end,
            IsCanBreakShield = function() return true end,
            GetCode = function() return code end,
            GetEffectCount = function(_, effectCode)
                return effectCode == DM_EFFECT_BREAKER and #choices or 0
            end,
            IsHasEffect = function(_, effectCode)
                for _, ability in ipairs(choices) do
                    if effectCode == ability + 1 then return true end
                end
                return false
            end,
        }
        Duel.SelectOption = function(_, ...)
            local descriptions = {...}
            check(#descriptions == #choices, "wrong breaker option count")
            for index, ability in ipairs(choices) do
                check(descriptions[index] == Auxiliary.break_select_list[ability],
                    "breaker option description mismatch")
            end
            return choice - 1
        end
        Duel.GetMatchingGroup = function()
            return {GetCount = function() return 5 end,
                Select = function(_, _, minimum, maximum)
                    check(minimum == expected and maximum == expected,
                        string.format("breaker mask=%d choice=%d expected=%d actual=%s/%s",
                            mask, choice, expected, tostring(minimum), tostring(maximum)))
                    error(selected)
                end}
        end
        local ok, err = pcall(Duel.BreakShield, {}, 0, 1, 1, 1, creature)
        check(not ok and err == selected, "breaker dispatch failed: " .. tostring(err))
        passed = passed + 1
    end
end

-- Exercise the production shield placement helper for every occupied/disabled
-- slot mask, for both players. No logical shield is renumbered or revealed.
local helperFirst = assert(source:find("function Auxiliary.MoveToShieldZone(", 1, true))
local helperLast = assert(source:find("\n--add a card to a player's shields face down", helperFirst, true))
assert(load(source:sub(helperFirst, helperLast - 1), "@utility_dmtcg.lua:MoveToShieldZone"))()
POS_FACEDOWN, DM_DESC_NOSZONES = 10, 999
for player = 0, 1 do
    for unavailable = 0, 31 do
        local moves, hints, chosen = 0, 0, nil
        local card = {GetOwner = function() return player end}
        Duel.CheckLocation = function(owner, location, sequence)
            check(owner == player and location == DM_LOCATION_SZONE,
                "shield availability inspected wrong owner or zone")
            check(sequence >= 0 and sequence < 5, "shield used reserved field slot")
            return math.floor(unavailable / 2 ^ sequence) % 2 == 0
        end
        Duel.MoveToField = function(moving, chooser, owner, location, position, enable, zone)
            check(moving == card and chooser == player and owner == player,
                "shield movement changed physical card or owner")
            check(location == DM_LOCATION_SZONE and position == POS_FACEDOWN and enable,
                "shield movement exposed a card or changed destination")
            moves, chosen = moves + 1, zone
            return true
        end
        Duel.Hint = function(kind, owner, description)
            check(kind == HINT_MESSAGE and owner == player and description == DM_DESC_NOSZONES,
                "shield emitted an unexpected hint")
            hints = hints + 1
        end
        local moved = Auxiliary.MoveToShieldZone(card)
        local firstFree
        for sequence = 0, 4 do
            if math.floor(unavailable / 2 ^ sequence) % 2 == 0 then
                firstFree = sequence
                break
            end
        end
        if firstFree then
            check(moved and moves == 1 and chosen == 2 ^ firstFree and hints == 0,
                "shield did not choose exactly the first available slot")
        else
            check(not moved and moves == 0 and hints == 1,
                "full shield zone attempted movement or omitted its existing diagnostic")
        end
        passed = passed + 1
    end
end
-- Model the native Group iterator contract, including invalidation by Merge of
-- an empty group. Execute the real helper against physical-card identities.
local evolutionFirst = assert(source:find("function Auxiliary.IncludeEvolutionSources(", 1, true))
local evolutionLast = assert(source:find("\n--========== Card ==========", evolutionFirst, true))
assert(load(source:sub(evolutionFirst, evolutionLast - 1), "@utility_dmtcg.lua:IncludeEvolutionSources"))()
local groupMethods = {}
local function makeGroup(cards)
    local group = setmetatable({cards = {}, membership = {}, version = 0}, {__index = groupMethods})
    for _, card in ipairs(cards or {}) do
        if not group.membership[card] then
            group.cards[#group.cards + 1] = card
            group.membership[card] = true
        end
    end
    return group
end
function groupMethods:Merge(other)
    self.version = self.version + 1
    for _, card in ipairs(other.cards) do
        if not self.membership[card] then
            self.cards[#self.cards + 1] = card
            self.membership[card] = true
        end
    end
end
function groupMethods:GetFirst()
    self.iteratorVersion, self.iteratorIndex = self.version, 1
    return self.cards[1]
end
function groupMethods:GetNext()
    check(self.iteratorVersion == self.version, "native Group iterator invalidated by mutation")
    self.iteratorIndex = self.iteratorIndex + 1
    return self.cards[self.iteratorIndex]
end
Group = {CreateGroup = function() return makeGroup() end}
aux = {Next = function(group)
    local started = false
    return function()
        if not started then
            started = true
            return group:GetFirst()
        end
        return group:GetNext()
    end
end}
local function makeCard(allowed, sources)
    return {
        visits = 0,
        IsCanSourceLeave = function(self)
            self.visits = self.visits + 1
            return allowed
        end,
        GetSourceGroup = function()
            check(allowed, "protected evolution sources were inspected")
            return makeGroup(sources)
        end,
    }
end
local sourceA, sourceB = makeCard(false), makeCard(false)
local ordinaryA, ordinaryB = makeCard(true), makeCard(true)
local evolutionA = makeCard(true, {sourceA})
local evolutionB = makeCard(true, {sourceA, sourceB})
local protected = makeCard(false, {sourceB})
local evolutionCases = {
    {name = "empty targets", targets = {}, expected = {}},
    {name = "ordinary cards with empty source groups", targets = {ordinaryA, ordinaryB}, expected = {ordinaryA, ordinaryB}},
    {name = "one allowed source", targets = {evolutionA}, expected = {evolutionA, sourceA}},
    {name = "multiple allowed sources", targets = {evolutionB}, expected = {evolutionB, sourceA, sourceB}},
    {name = "allowed and protected sources", targets = {evolutionA, protected}, expected = {evolutionA, protected, sourceA}},
    {name = "shared and already selected sources", targets = {evolutionA, evolutionB, sourceA}, expected = {evolutionA, evolutionB, sourceA, sourceB}},
}
for _, case in ipairs(evolutionCases) do
    for _, card in ipairs({ordinaryA, ordinaryB, evolutionA, evolutionB, protected, sourceA, sourceB}) do
        card.visits = 0
    end
    local targets = makeGroup(case.targets)
    local returned = Auxiliary.IncludeEvolutionSources(targets)
    check(returned == targets, case.name .. ": replaced caller group")
    check(#targets.cards == #case.expected, case.name .. ": wrong resulting card count")
    for _, card in ipairs(case.expected) do
        check(targets.membership[card], case.name .. ": lost physical-card identity")
    end
    local original = makeGroup(case.targets)
    for _, card in ipairs(case.expected) do
        check(card.visits == (original.membership[card] and 1 or 0),
            case.name .. ": did not visit each original card exactly once")
    end
    passed = passed + 1
end
check(passed == 155, "a required regression case did not execute")
print(string.format("PASS: %d rules regressions (72 startup, 13 breaker choices, 64 shield slots, 6 evolution groups)", passed))
