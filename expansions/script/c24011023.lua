--Warped Lunatron
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (do not untap)
	dm.EnableEffectCustom(c,DM_EFFECT_DONOT_UNTAP_START_STEP,nil,DM_LOCATION_BZONE,DM_LOCATION_BZONE)
	--tap, untap
	dm.AddTriggerEffect(c,0,EVENT_CUSTOM+DM_EVENT_UNTAP_START_STEP,true,scard.postg,scard.posop,nil,scard.poscon)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsControler(tp) and c:IsUntapped()
end
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and eg:IsExists(scard.cfilter,1,nil,tp)
end
scard.postg=dm.CheckCardFunction(dm.ManaZoneFilter(Card.IsAbleToTap),DM_LOCATION_MZONE,0)
function scard.posfilter(c)
	return c:IsFaceup() and c:IsAbleToUntap()
end
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(dm.ManaZoneFilter(Card.IsAbleToTap),tp,DM_LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TAP)
	local g1=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(Card.IsAbleToTap),tp,DM_LOCATION_MZONE,0,1,ct1,nil)
	local ct2=Duel.Tap(g1,REASON_EFFECT)
	if ct2<2 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_UNTAP)
	local g2=Duel.SelectMatchingCard(tp,scard.posfilter,tp,DM_LOCATION_BZONE,0,math.floor(ct2/2),math.floor(ct2/2),nil)
	if g2:GetCount()==0 then return end
	Duel.HintSelection(g2)
	Duel.Untap(g2,REASON_EFFECT)
end
