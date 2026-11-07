--Hurricane Crawler
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana zone, return
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsAbleToMZone,tp,LOCATION_HAND,0,nil)
	if g1:GetCount()==0 then return end
	local ct=Duel.SendtoMZone(g1,POS_FACEUP_UNTAPPED,REASON_EFFECT)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g2=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_MZONE,0,ct,ct,nil)
	if g2:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.SendtoHand(g2,PLAYER_OWNER,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g2)
end
