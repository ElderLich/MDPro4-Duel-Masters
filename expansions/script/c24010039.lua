--Siren Concerto
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--return, to mana zone
	dm.AddSpellCastEffect(c,0,nil,scard.retop)
end
scard.duel_masters_card=true
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_MZONE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.SendtoHand(g1,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g1)
		Duel.ShuffleHand(tp)
	end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOMZONE)
	local g2=Duel.SelectMatchingCard(tp,Card.IsAbleToMZone,tp,LOCATION_HAND,0,1,1,e:GetHandler())
	if g2:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SendtoMZone(g2,POS_FACEUP_UNTAPPED,REASON_EFFECT)
	end
end
