--Smash Warrior Stagrandu
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--attack untapped
	dm.EnableAttackUntapped(c)
	--get ability
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,nil,scard.abop,nil,scard.abcon)
end
scard.duel_masters_card=true
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsFaceup() and d:IsPowerAbove(6000)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	--power up
	dm.RegisterEffectUpdatePower(c,c,1,9000)
end
