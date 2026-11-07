--カラミティ・ドラゴン
--Calamity Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--power attacker
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_ATTACK_ANNOUNCE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetOperation(scard.regop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_UPDATE_POWER)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BZONE)
	e1:SetLabelObject(e0)
	e1:SetCondition(dm.SelfAttackerCondition)
	e1:SetValue(scard.powval)
	c:RegisterEffect(e1)
	dm.EnableEffectCustom(c,DM_EFFECT_POWER_ATTACKER)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.dbcon)
	dm.AddEffectDescription(c,0,scard.dbcon)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER,scard.tbcon)
	dm.AddEffectDescription(c,1,scard.tbcon)
end
scard.duel_masters_card=true
--power attacker
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	local os=require('os')
	math.randomseed(os.time())
	local t={5000,6000,7000,8000,9000,10000,11000,12000,13000,14000}
	local val=t[math.random(#t)]
	e:SetLabel(val)
end
function scard.powval(e,c)
	return e:GetLabelObject():GetLabel()
end
--double breaker
function scard.dbcon(e)
	return e:GetHandler():IsPowerAbove(6000)
end
--triple breaker
function scard.tbcon(e)
	return e:GetHandler():IsPowerAbove(12000)
end
