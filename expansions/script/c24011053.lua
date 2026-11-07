--Hide and Seek
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--return, discard
	dm.AddSpellCastEffect(c,0,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and not c:IsEvolution() and c:IsAbleToHand()
end
scard.rettg=dm.TargetCardFunction(PLAYER_SELF,scard.retfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_RTOHAND)
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and scard.retfilter(tc) then
		Duel.SendtoHand(tc,PLAYER_OWNER,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
	Duel.BreakEffect()
	Duel.RandomDiscardHand(1-tp,1,REASON_EFFECT)
end
