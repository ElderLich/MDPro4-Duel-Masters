--Cloned Blade
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy
	dm.AddSpellCastEffect(c,0,scard.destg,scard.desop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(3000)
end
function scard.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,scard.desfilter,tp,0,DM_LOCATION_BZONE,1,1,nil)
	local ct=Duel.GetMatchingGroupCount(dm.DMGraveFilter(Card.IsCode),tp,DM_LOCATION_GRAVE,DM_LOCATION_GRAVE,nil,CARD_CLONED_BLADE)
	if g:GetCount()==0 or ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	Duel.SelectTarget(tp,scard.desfilter,tp,0,DM_LOCATION_BZONE,0,ct,g)
end
scard.desop=dm.TargetCardsOperation(Duel.Destroy,REASON_EFFECT)
