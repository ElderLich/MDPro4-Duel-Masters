--Q-tronic Hypermind
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_SURVIVOR))
	--draw
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.drtg,scard.drop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_SURVIVOR}
function scard.cfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_SURVIVOR)
end
function scard.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.IsExistingMatchingCard(scard.cfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,1,nil) end
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
