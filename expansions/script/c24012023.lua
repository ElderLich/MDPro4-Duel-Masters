--Cloned Spiral
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--return
	dm.AddSpellCastEffect(c,0,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function scard.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,scard.retfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,1,1,nil)
	local ct=Duel.GetMatchingGroupCount(dm.DMGraveFilter(Card.IsCode),tp,DM_LOCATION_GRAVE,DM_LOCATION_GRAVE,nil,CARD_CLONED_SPIRAL)
	if g:GetCount()==0 or ct==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	Duel.SelectTarget(tp,scard.retfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,0,ct,g)
end
scard.retop=dm.TargetSendtoHandOperation()
