--Überdragon Jabaha
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_ARMORED_DRAGON))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability (power attacker)
	dm.AddStaticEffectPowerAttacker(c,2000,DM_LOCATION_BZONE,0,dm.TargetBoolFunctionExceptSelf())
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_ARMORED_DRAGON,DM_RACE_DRAGON}
