--Mudman
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,2000,dm.MZoneExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_DARKNESS))
	dm.AddEffectDescription(c,0,dm.MZoneExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_DARKNESS))
end
scard.duel_masters_card=true
