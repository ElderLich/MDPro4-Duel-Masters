--Wave Lance
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--return, draw
	dm.AddSpellCastEffect(c,0,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
scard.rettg=dm.TargetCardFunction(PLAYER_SELF,scard.retfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE,1,1,DM_HINTMSG_RTOHAND)
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not scard.retfilter(tc) then return end
	Duel.SendtoHand(tc,PLAYER_OWNER,REASON_EFFECT)
	if tc:DMIsRace(DM_RACE_DRAGON) and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,DM_QHINTMSG_DRAW) then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end
