--Legendary Bynor
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_LEVIATHAN))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability (cannot be blocked)
	dm.AddStaticEffectCannotBeBlocked(c,DM_LOCATION_BZONE,0,dm.TargetBoolFunctionExceptSelf(Card.IsCivilization,DM_CIVILIZATION_WATER))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_LEVIATHAN}
