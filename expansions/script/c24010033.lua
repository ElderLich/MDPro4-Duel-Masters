--Crystal Spinslicer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_LIQUID_PEOPLE))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_LIQUID_PEOPLE}
