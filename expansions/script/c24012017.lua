--Hydrooze, the Mutant Emperor
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CYBER_LORD,DM_RACE_HEDRIAN))
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BZONE,0,dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_CYBER_LORD,DM_RACE_HEDRIAN))
	--get ability (cannot be blocked)
	dm.AddStaticEffectCannotBeBlocked(c,DM_LOCATION_BZONE,0,aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_CYBER_LORD,DM_RACE_HEDRIAN))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_CYBER_LORD,DM_RACE_CYBER,DM_RACE_HEDRIAN}
