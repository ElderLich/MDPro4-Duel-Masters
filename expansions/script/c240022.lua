--Giliam, the Tormentor
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker (light)
	dm.EnableBlocker(c,nil,DM_DESC_LIGHT_BLOCKER,aux.FilterBoolFunction(Card.IsCivilization,DM_CIVILIZATION_LIGHT))
	--cannot be destroyed
	dm.EnableCannotBeBattleDestroyed(c,scard.indval)
end
scard.duel_masters_card=true
function scard.indval(e,c)
	return c:IsCivilization(DM_CIVILIZATION_LIGHT)
end
