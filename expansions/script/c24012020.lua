--Comet Eye, the Spectral Spud
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_WILD_VEGGIES,DM_RACE_RAINBOW_PHANTOM))
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BZONE,0,dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_WILD_VEGGIES,DM_RACE_RAINBOW_PHANTOM))
	--untap
	dm.AddTriggerEffect(c,0,EVENT_PHASE+PHASE_END,true,scard.postg,scard.posop,nil,scard.poscon)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_WILD_VEGGIES,DM_RACE_RAINBOW_PHANTOM}
scard.poscon=dm.TurnPlayerCondition(PLAYER_SELF)
function scard.posfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_WILD_VEGGIES,DM_RACE_RAINBOW_PHANTOM) and c:IsAbleToUntap()
end
scard.postg=dm.CheckCardFunction(scard.posfilter,DM_LOCATION_BZONE,0)
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(scard.posfilter,tp,DM_LOCATION_BZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_UNTAP)
	local g=Duel.SelectMatchingCard(tp,scard.posfilter,tp,DM_LOCATION_BZONE,0,1,ct,nil)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	Duel.Untap(g,REASON_EFFECT)
end
