--Ghastly Drain
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to hand
	dm.AddSpellCastEffect(c,0,scard.thtg,scard.thop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.thfilter(c,e)
	return c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function scard.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_SZONE) and chkc:IsControler(tp) and chkc:IsAbleToHand() end
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(dm.ShieldZoneFilter(scard.thfilter),tp,DM_LOCATION_SZONE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_ATOHAND)
	Duel.SelectTarget(tp,dm.ShieldZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_SZONE,0,0,ct,nil)
end
scard.thop=dm.TargetSendtoHandOperation()
