--Dolmarks, the Shadow Warrior
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy, to grave
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.desop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.desfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function scard.tgfilter(c,e)
	return c:DMIsAbleToGrave() and c:IsCanBeEffectTarget(e)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,DM_LOCATION_BZONE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.HintSelection(g1)
		Duel.Destroy(g1,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(Card.DMIsAbleToGrave),tp,DM_LOCATION_MZONE,0,1,1,nil)
	if g2:GetCount()>0 then
		Duel.DMSendtoGrave(g2,REASON_EFFECT)
	end
	Duel.BreakEffect()
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_DESTROY)
	local g3=Duel.SelectMatchingCard(1-tp,scard.desfilter,1-tp,DM_LOCATION_BZONE,0,1,1,nil,e)
	if g3:GetCount()>0 then
		Duel.SetTargetCard(g3)
		Duel.Destroy(g3,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TOGRAVE)
	local g4=Duel.SelectMatchingCard(1-tp,dm.ManaZoneFilter(scard.tgfilter),1-tp,DM_LOCATION_MZONE,0,1,1,nil,e)
	if g4:GetCount()>0 then
		Duel.SetTargetCard(g4)
		Duel.DMSendtoGrave(g4,REASON_EFFECT)
	end
end
