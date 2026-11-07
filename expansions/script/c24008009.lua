--Migalo, Vizier of Spycraft
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--turbo rush
	dm.EnableTurboRush(c,scard.abop)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	--confirm
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_ATTACK_ANNOUNCE)
	e1:SetProperty(DM_EFFECT_FLAG_CHAIN_LIMIT)
	e1:SetTarget(dm.CheckCardFunction(dm.ShieldZoneFilter(Card.IsFacedown),0,DM_LOCATION_SZONE))
	e1:SetOperation(dm.ConfirmOperation(tp,dm.ShieldZoneFilter(Card.IsFacedown),0,DM_LOCATION_SZONE,2))
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e1)
end
