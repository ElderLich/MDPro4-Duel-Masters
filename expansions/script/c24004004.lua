--Doboulgyser, Giant Rock Beast
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_ROCK_BEAST))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--destroy
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.destg,scard.desop)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_ROCK_BEAST}
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(3000)
end
scard.destg=dm.CheckCardFunction(scard.desfilter,0,DM_LOCATION_BZONE)
scard.desop=dm.DestroyOperation(PLAYER_SELF,scard.desfilter,0,DM_LOCATION_BZONE,1)
