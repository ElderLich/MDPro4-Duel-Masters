--Larba Geer, the Immaculate
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GUARDIAN))
	--tap
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.TapOperation(nil,scard.posfilter,0,DM_LOCATION_BZONE))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_GUARDIAN}
function scard.posfilter(c)
	return c:IsFaceup() and c:IsHasEffect(DM_EFFECT_BLOCKER) and c:IsAbleToTap()
end
