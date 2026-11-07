--生命と霊力の変換
--Flesh-to-Spirit Conversion
--Not fully implemented: Face-down banished cards are first sent to a player's hand before they are banished face-up
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--send replace (to mana zone)
	dm.AddSpellCastEffect(c,0,nil,scard.regop)
end
scard.duel_masters_card=true
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetTarget(scard.reptg)
	e1:SetValue(scard.repval)
	e1:SetOperation(scard.repop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function scard.repfilter(c,tp)
	if c:GetDestination()==LOCATION_REMOVED and c:IsLocation(LOCATION_GRAVE) then return false end
	if c:GetDestination()==LOCATION_GRAVE and not c:IsLocation(DM_LOCATION_BZONE) then return false end
	return c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
end
function scard.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(scard.repfilter,1,c,tp) end
	local g=eg:Filter(scard.repfilter,c,tp)
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function scard.repval(e,c)
	return scard.repfilter(c,e:GetHandlerPlayer())
end
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SendtoMZone(e:GetLabelObject(),POS_FACEUP_TAPPED,REASON_EFFECT+REASON_REPLACE)
end
