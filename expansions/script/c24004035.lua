--Purple Piercer
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be attacked
	dm.EnableCannotBeAttacked(c,aux.TargetBoolFunction(Card.IsCivilization,DM_CIVILIZATION_LIGHT))
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,dm.CannotBeBlockedBoolFunction(Card.IsCivilization,DM_CIVILIZATION_LIGHT))
end
scard.duel_masters_card=true
