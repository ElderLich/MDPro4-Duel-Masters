--Emeral
--Note: Changed effect to match YGOPro's game system
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to shield zone, to hand
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.tstg,scard.tsop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.tstg=dm.CheckCardFunction(Card.IsAbleToSZone,LOCATION_HAND,0)
function scard.thfilter(c,e)
	return c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	--Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOSZONE)
	--local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToSZone,tp,LOCATION_HAND,0,1,1,nil)
	--if g1:GetCount()==0 or Duel.SendtoSZone(g1)==0 then return end
	--Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_ATOHAND)
	--local g2=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(scard.thfilter),tp,DM_LOCATION_SZONE,0,1,1,nil,e)
	--if g2:GetCount()==0 then return end
	--Duel.SetTargetCard(g2)
	--Duel.SendtoHand(g2,PLAYER_OWNER,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsAbleToSZone,tp,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOSZONE)
	local sg1=g:Select(tp,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_ATOHAND)
	local sg2=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(scard.thfilter),tp,DM_LOCATION_SZONE,0,1,1,nil,e)
	if sg2:GetCount()==0 then return end
	Duel.SetTargetCard(sg2)
	Duel.SendtoHand(sg2,PLAYER_OWNER,REASON_EFFECT)
	Duel.ShuffleHand(tp)
	Duel.SendtoSZone(sg1)
end
