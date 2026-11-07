--緑神龍ハルクーンベルガ
--Terradragon Hulcoon Berga
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (power attacker)
	dm.AddStaticEffectPowerAttacker(c,4000,DM_LOCATION_BZONE,0,dm.TargetBoolFunctionExceptSelf(),dm.SelfTappedCondition)
	--get ability (double breaker)
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,dm.SelfTappedCondition,DM_LOCATION_BZONE,0,dm.TargetBoolFunctionExceptSelf())
	--get ability
	dm.AddTriggerEffect(c,1,EVENT_PHASE+PHASE_END,nil,nil,scard.powop,nil,dm.SelfTappedCondition)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.dbcon)
	dm.AddEffectDescription(c,2,scard.dbcon)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER,scard.tbcon)
	dm.AddEffectDescription(c,3,scard.tbcon)
end
scard.duel_masters_card=true
--get ability
function scard.powop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	local os=require('os')
	math.randomseed(os.time())
	local t={1000,2000,3000,4000,5000}
	local val=t[math.random(#t)]
	--power up
	dm.RegisterEffectUpdatePower(c,c,1,val,0,0)
end
--double breaker
function scard.dbcon(e)
	return e:GetHandler():IsPowerAbove(6000)
end
--triple breaker
function scard.tbcon(e)
	return e:GetHandler():IsPowerAbove(9000)
end
--[[
	Notes
		1. The possible increase amount of this card in the original video game is 1000 to 5000 per turn
		https://duelmasters.fandom.com/wiki/Terradragon_Hulcoon_Berga#Notes
]]
