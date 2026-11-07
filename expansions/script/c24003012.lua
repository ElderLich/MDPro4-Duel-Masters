--Angler Cluster
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack
	dm.EnableCannotAttack(c)
	--power up
	dm.EnableUpdatePower(c,3000,dm.MZoneExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_WATER))
	dm.AddEffectDescription(c,0,dm.MZoneExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_WATER))
end
scard.duel_masters_card=true
