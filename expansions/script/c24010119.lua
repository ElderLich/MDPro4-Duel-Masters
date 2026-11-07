--Bluum Erkis, Flare Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--break replace (confirm, cast for no cost or to hand)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EFFECT_SEND_REPLACE)
	e1:SetRange(DM_LOCATION_BZONE)
	e1:SetTarget(scard.reptg)
	e1:SetValue(scard.repval)
	e1:SetOperation(scard.repop)
	c:RegisterEffect(e1)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.repfilter(c,tp)
	return c:IsLocation(DM_LOCATION_SZONE) and c:IsControler(1-tp)
		and c:GetDestination()~=DM_LOCATION_SZONE and not c:IsReason(REASON_REPLACE)
end
function scard.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return re:GetHandler()==e:GetHandler()
		and eg:IsExists(scard.repfilter,1,nil,tp) and bit.band(r,DM_REASON_BREAK)~=0 end
	local g=eg:Filter(scard.repfilter,nil,tp)
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function scard.repval(e,c)
	return scard.repfilter(c,e:GetHandlerPlayer())
end
function scard.castfilter(c)
	return c:IsSpell() and c:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER)
end
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	local g=e:GetLabelObject()
	Duel.ConfirmCards(tp,g)
	local sg1=g:Filter(scard.castfilter,nil)
	Duel.CastFree(sg1,tp,REASON_EFFECT+REASON_REPLACE)
	local sg2=g:Filter(aux.NOT(scard.castfilter),nil)
	Duel.SendtoHand(sg2,PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
end
