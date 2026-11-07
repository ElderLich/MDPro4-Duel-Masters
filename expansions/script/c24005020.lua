--Pokolul
--Not fully implemented: Other tapped Pokolul can trigger even though they didn't break the current broken shield
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--untap
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_CUSTOM+DM_EVENT_BREAK_SHIELD)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e0:SetRange(DM_LOCATION_BZONE)
	e0:SetCondition(scard.regcon)
	e0:SetOperation(scard.regop1)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(DM_LOCATION_BZONE)
	e1:SetOperation(scard.regop2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_CHAIN_SOLVED)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(DM_LOCATION_BZONE)
	e2:SetOperation(scard.regop3)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(sid,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAIN_END)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL+EFFECT_FLAG_DELAY)
	e3:SetRange(DM_LOCATION_BZONE)
	e3:SetCondition(scard.poscon)
	e3:SetTarget(dm.SelfUntapTarget)
	e3:SetOperation(scard.posop)
	c:RegisterEffect(e3)
	e1:SetLabelObject(e3)
	e2:SetLabelObject(e3)
end
scard.duel_masters_card=true
function scard.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function scard.regop1(e,tp,eg,ep,ev,re,r,rp)
	for ec in aux.Next(eg) do
		ec:RegisterFlagEffect(sid,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function scard.regop2(e,tp,eg,ep,ev,re,r,rp)
	e:GetLabelObject():SetLabel(0)
end
function scard.regop3(e,tp,eg,ep,ev,re,r,rp)
	if rp==tp or not re:IsHasCategory(DM_CATEGORY_SHIELD_TRIGGER) or re:GetHandler():GetFlagEffect(sid)==0 then return end
	e:GetLabelObject():SetLabel(1)
end
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetLabel()==1
end
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	Duel.Untap(c,REASON_EFFECT)
	--part of workaround to not tap a creature that untaps itself with an ability
	--Note: Remove this if YGOPro allows a creature to tap itself for EFFECT_ATTACK_COST
	c:RegisterFlagEffect(DM_EFFECT_IGNORE_TAP,RESET_EVENT+RESETS_STANDARD,0,1)
end
