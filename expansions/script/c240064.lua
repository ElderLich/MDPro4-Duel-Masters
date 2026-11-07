--Star-Cry Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,3000,nil,DM_LOCATION_BZONE,0,dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_ARMORED_DRAGON))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
