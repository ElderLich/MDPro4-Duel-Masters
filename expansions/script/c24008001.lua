--Kuukai, Finder of Karma
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
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
