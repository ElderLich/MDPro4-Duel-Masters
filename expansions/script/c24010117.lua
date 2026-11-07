--Bodacious Giant
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--must attack
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_BE_BATTLE_TARGET)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(DM_LOCATION_BZONE)
	e0:SetOperation(scard.regop)
	c:RegisterEffect(e0)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_ATTACK)
	e1:SetRange(DM_LOCATION_BZONE)
	e1:SetTargetRange(0,DM_LOCATION_BZONE)
	e1:SetCondition(scard.macon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(DM_EFFECT_MUST_ATTACK_CREATURE)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_MUST_BE_ATTACKED)
	e3:SetCondition(scard.macon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
scard.duel_masters_card=true
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(sid,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function scard.macon(e)
	return e:GetHandler():IsTapped() and e:GetHandler():GetFlagEffect(sid)==0
end
