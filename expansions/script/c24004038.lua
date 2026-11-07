--Soul Gulp
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--discard
	dm.AddSpellCastEffect(c,0,scard.dhtg,scard.dhop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_LIGHT)
end
function scard.dhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(1-tp) end
	if chk==0 then return true end
	local ct=Duel.GetMatchingGroupCount(scard.cfilter,tp,0,DM_LOCATION_BZONE,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_DISCARD)
	Duel.SelectTarget(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,ct,ct,nil)
end
scard.dhop=dm.TargetCardsOperation(Duel.DMSendtoGrave,REASON_EFFECT+REASON_DISCARD)
