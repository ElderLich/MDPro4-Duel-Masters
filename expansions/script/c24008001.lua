--Kuukai, Finder of Karma
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_MECHA_THUNDER))
	--untap
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_BATTLE_END,nil,nil,dm.SelfUntapOperation(),nil,dm.SelfBlockCondition)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_MECHA_THUNDER}
