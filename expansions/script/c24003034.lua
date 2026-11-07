--Armored Warrior Quelos
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,nil,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tgfilter1(c)
	return not c:IsCivilization(DM_CIVILIZATION_FIRE) and c:DMIsAbleToGrave()
end
function scard.tgfilter2(c,e)
	return scard.tgfilter1(c) and c:IsCanBeEffectTarget(e)
end
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	local g1=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(scard.tgfilter1),tp,DM_LOCATION_MZONE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.DMSendtoGrave(g1,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(1-tp,dm.ManaZoneFilter(scard.tgfilter2),1-tp,DM_LOCATION_MZONE,0,1,1,nil,e)
	if g2:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.SetTargetCard(g2)
	Duel.DMSendtoGrave(g2,REASON_EFFECT)
end
