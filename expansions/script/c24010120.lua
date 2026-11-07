--Deklowaz, the Terminator
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (destroy, discard)
	dm.EnableTapAbility(c,0,scard.destg,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(3000)
end
function scard.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.desfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,1,nil)
		or Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) end
end
function scard.dhfilter(c)
	return c:IsPowerBelow(3000)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(scard.desfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil)
	Duel.Destroy(g1,REASON_EFFECT)
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g2:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.ConfirmCards(tp,g2)
	local sg=g2:Filter(scard.dhfilter,nil)
	Duel.DMSendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	Duel.ShuffleHand(1-tp)
end
