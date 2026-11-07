--Cloned Deflector
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--tap
	dm.AddSpellCastEffect(c,0,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsAbleToTap()
end
function scard.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TAP)
	local g=Duel.SelectTarget(tp,scard.posfilter,tp,0,DM_LOCATION_BZONE,1,1,nil)
	local ct=Duel.GetMatchingGroupCount(dm.DMGraveFilter(Card.IsCode),tp,DM_LOCATION_GRAVE,DM_LOCATION_GRAVE,nil,CARD_CLONED_DEFLECTOR)
	if g:GetCount()==0 or ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TAP)
	Duel.SelectTarget(tp,scard.posfilter,tp,0,DM_LOCATION_BZONE,0,ct,g)
end
scard.posop=dm.TargetCardsOperation(Duel.Tap,REASON_EFFECT)
