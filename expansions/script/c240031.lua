--Olgate, Nightmare Samurai
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--untap
	dm.AddTriggerEffect(c,0,EVENT_DESTROYED,true,dm.SelfUntapTarget,scard.posop,nil,scard.poscon)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsCreature() and c:GetPreviousControler()==tp
end
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil,tp)
end
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	Duel.Untap(c,REASON_EFFECT)
end
