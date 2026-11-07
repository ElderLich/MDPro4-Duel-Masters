--エンペラー・アロエラ
--Emperor Aloera
--Note: Changed effect to match YGOPro's game system
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CYBER_LORD))
	--to shield zone, to hand
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.tstg,scard.tsop)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_CYBER_LORD,DM_RACE_CYBER}
scard.tstg=dm.CheckCardFunction(Card.IsAbleToSZone,LOCATION_HAND,0)
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	local szone_count=Duel.GetLocationCount(tp,DM_LOCATION_SZONE)
	--Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOSZONE)
	--local g1=Duel.SelectMatchingCard(tp,Card.IsAbleToSZone,tp,LOCATION_HAND,0,1,szone_count,nil)
	--if g1:GetCount()==0 or Duel.SendtoSZone(g1)==0 then return end
	--Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_ATOHAND)
	--local g2=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_SZONE,0,g1:GetCount(),g1:GetCount(),nil)
	--Duel.HintSelection(g2)
	--Duel.SendtoHand(g2,PLAYER_OWNER,REASON_EFFECT)
	local g=Duel.GetMatchingGroup(Card.IsAbleToSZone,tp,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOSZONE)
	local sg1=g:Select(tp,1,szone_count,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_ATOHAND)
	local sg2=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_SZONE,0,sg1:GetCount(),sg1:GetCount(),nil)
	if sg2:GetCount()==0 then return end
	Duel.HintSelection(sg2)
	Duel.SendtoHand(sg2,PLAYER_OWNER,REASON_EFFECT)
	Duel.ShuffleHand(tp)
	Duel.SendtoSZone(sg1)
end
