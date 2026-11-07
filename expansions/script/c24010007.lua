--Carnival Totem
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--return, to mana zone
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.retop)
end
scard.duel_masters_card=true
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(dm.ManaZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_MZONE,0,nil)
	Duel.SendtoHand(g1,PLAYER_OWNER,REASON_EFFECT)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToMZone,tp,LOCATION_HAND,0,nil)
	g2:Sub(Duel.GetOperatedGroup())
	Duel.SendtoMZone(g2,POS_FACEUP_TAPPED,REASON_EFFECT)
end
