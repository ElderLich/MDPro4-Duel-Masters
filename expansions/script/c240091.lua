--Neve, the Leveler
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--search (to hand)
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.thop,nil,scard.thcon)
end
scard.duel_masters_card=true
function scard.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,DM_LOCATION_BZONE,nil)
	local ct2=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,nil)
	return ct1>ct2
end
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,DM_LOCATION_BZONE,nil)
	local ct2=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,nil)
	local ct=ct1-ct2
	if ct<=0 then return end
	dm.SendtoHandOperation(PLAYER_SELF,Card.IsCreature,LOCATION_DECK,0,0,ct,true)(e,tp,eg,ep,ev,re,r,rp)
end
