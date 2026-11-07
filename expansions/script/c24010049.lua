--Gigandura
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana zone, return
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.tmop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tmfilter(c,e)
	return c:IsAbleToMZone() and c:IsCanBeEffectTarget(e)
end
function scard.retfilter(c,e)
	return c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g1:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g1)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOMZONE)
	local sg=g1:FilterSelect(tp,scard.tmfilter,0,1,nil,e)
	if sg:GetCount()>0 then
		Duel.SetTargetCard(sg)
		Duel.SendtoMZone(sg,POS_FACEUP_UNTAPPED,REASON_EFFECT)
	else
		Duel.ShuffleHand(1-tp)
		return
	end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g2=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(scard.retfilter),tp,0,DM_LOCATION_MZONE,1,1,nil,e)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoHand(g2,PLAYER_OWNER,REASON_EFFECT)
	Duel.ConfirmCards(tp,g2)
end
