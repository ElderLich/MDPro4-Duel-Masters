--Rumblesaur Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (speed attacker)
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER,nil,LOCATION_ALL,0,dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_SURVIVOR))
end
scard.duel_masters_card=true
