--Ballom, Master of Death
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_DEMON_COMMAND))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--destroy
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.DestroyOperation(nil,scard.desfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_DEMON_COMMAND,DM_RACE_COMMAND}
function scard.desfilter(c)
	return c:IsFaceup() and not c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
