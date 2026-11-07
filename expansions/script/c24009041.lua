--Relentless Blitz
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.regop)
end
scard.duel_masters_card=true
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RACE)
	local race=Duel.DMAnnounceRace(tp)
	--attack untapped
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_ATTACK_UNTAPPED)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(DM_LOCATION_BZONE,DM_LOCATION_BZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.DMIsRace,race))
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e2,tp)
	--cannot be blocked
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetRange(DM_LOCATION_BZONE)
	e3:SetTargetRange(1,1)
	e3:SetCondition(aux.AND(dm.SelfAttackerCondition,scard.actcon))
	e3:SetValue(dm.CannotBeBlockedValue())
	local e4=e2:Clone()
	e4:SetLabelObject(e3)
	Duel.RegisterEffect(e4,tp)
	local e5=Effect.CreateEffect(e:GetHandler())
	e5:SetDescription(aux.Stringid(sid,2))
	e5:SetType(EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	local e6=e2:Clone()
	e6:SetLabelObject(e5)
	Duel.RegisterEffect(e6,tp)
end
function scard.actcon(e)
	local d=Duel.GetAttackTarget()
	return d and d:IsFaceup()
end
