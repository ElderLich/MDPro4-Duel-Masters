--邪魂転生
--Wicked Soul Reincarnation
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to grave, draw
	dm.AddSpellCastEffect(c,0,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tgfilter(c)
	return c:IsFaceup() and c:DMIsAbleToGrave()
end
function scard.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_BZONE) and chkc:IsControler(tp) and scard.tgfilter(chkc) end
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(scard.tgfilter,tp,DM_LOCATION_BZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	Duel.SelectTarget(tp,scard.tgfilter,tp,DM_LOCATION_BZONE,0,0,ct,nil)
end
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	local ct=Duel.DMSendtoGrave(g,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(tp,ct*2,REASON_EFFECT)
end
