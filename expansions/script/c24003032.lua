--Snake Attack
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability, to grave
	dm.AddSpellCastEffect(c,0,nil,scard.abop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tgfilter(c,e)
	return c:DMIsAbleToGrave() and c:IsCanBeEffectTarget(e)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,nil)
	if g1:GetCount()>0 then
		for tc in aux.Next(g1) do
			--double breaker
			dm.RegisterEffectBreaker(e:GetHandler(),tc,1,DM_EFFECT_DOUBLE_BREAKER)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	local g2=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(scard.tgfilter),tp,DM_LOCATION_SZONE,0,1,1,nil,e)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.DMSendtoGrave(g2,REASON_EFFECT)
end
