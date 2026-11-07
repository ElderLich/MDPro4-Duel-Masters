--Eldritch Poison
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--destroy, return
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
function scard.retfilter(c)
	return c:IsCreature() and c:IsAbleToHand()
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,scard.desfilter,tp,DM_LOCATION_BZONE,0,0,1,nil)
	if g1:GetCount()==0 then return end
	Duel.HintSelection(g1)
	if Duel.Destroy(g1,REASON_EFFECT)==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g2=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(scard.retfilter),tp,DM_LOCATION_MZONE,0,1,1,nil)
	if g2:GetCount()==0 then return end
	Duel.SendtoHand(g2,PLAYER_OWNER,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g2)
end
