--パシフィック・チャンピオン
--Pacific Champion
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_MERFOLK))
	--cannot be attacked
	dm.EnableCannotBeAttacked(c,aux.NOT(aux.TargetBoolFunction(Card.IsEvolution)))
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,aux.NOT(dm.CannotBeBlockedBoolFunction(Card.IsEvolution)))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_MERFOLK}
