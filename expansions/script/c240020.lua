--Amnis, Holy Elemental
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker (darkness)
	dm.EnableBlocker(c,nil,DM_DESC_DARKNESS_BLOCKER,aux.FilterBoolFunction(Card.IsCivilization,DM_CIVILIZATION_DARKNESS))
	--cannot be destroyed
	dm.EnableCannotBeBattleDestroyed(c,scard.indval)
end
scard.duel_masters_card=true
function scard.indval(e,c)
	return c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
