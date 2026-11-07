--Miraculous Meltdown
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to hand
	dm.AddSpellCastEffect(c,0,scard.thtg,scard.thop,EFFECT_FLAG_CARD_TARGET,scard.thcon)
end
scard.duel_masters_card=true
function scard.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetShieldCount(1-tp)>Duel.GetShieldCount(tp)
end
function scard.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(DM_LOCATION_SZONE) and chkc:IsControler(1-tp) and dm.ShieldZoneFilter()(chkc) end
	if chk==0 then return true end
	local ct=Duel.GetShieldCount(tp)
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TARGET)
	Duel.SelectTarget(1-tp,dm.ShieldZoneFilter(),1-tp,DM_LOCATION_SZONE,0,ct,ct,nil)
end
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(dm.ShieldZoneFilter(Card.IsAbleToHand),tp,0,DM_LOCATION_SZONE,nil)
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g2:GetCount()>0 then g1:Sub(g2) end
	Duel.SendtoHand(g1,PLAYER_OWNER,REASON_EFFECT,true)
end
