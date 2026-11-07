--Pointa, the Aqua Shadow
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm, discard
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.confop)
end
scard.duel_masters_card=true
function scard.confop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(Card.IsFacedown),tp,0,DM_LOCATION_SZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.ConfirmCards(tp,g)
	end
	Duel.BreakEffect()
	Duel.RandomDiscardHand(1-tp,1,REASON_EFFECT)
end
