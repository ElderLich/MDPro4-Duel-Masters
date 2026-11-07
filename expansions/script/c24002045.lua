--Barkwhip, the Smasher
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_BEAST_FOLK))
	--power up
	dm.EnableUpdatePower(c,2000,dm.SelfTappedCondition,DM_LOCATION_BZONE,0,dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_BEAST_FOLK))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_BEAST_FOLK}
