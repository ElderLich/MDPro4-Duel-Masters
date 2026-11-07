--ボルブレイズ・ドラゴン
--Bolblaze Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--to grave (mana)
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.tgtg1,scard.tgop1)
	--to grave (shield)
	dm.AddTriggerEffect(c,1,EVENT_CUSTOM+DM_EVENT_BREAK_SHIELD,true,scard.tgtg2,scard.tgop2,nil,scard.tgcon)
	--attack untapped
	dm.EnableAttackUntapped(c)
end
scard.duel_masters_card=true
scard.tgtg1=dm.CheckCardFunction(dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MZONE)
scard.tgop1=dm.SendtoGraveOperation(PLAYER_OPPO,dm.ManaZoneFilter(),0,DM_LOCATION_MZONE,1)
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(Card.DMIsAbleToGrave,nil)
	g:KeepAlive()
	e:SetLabelObject(g)
	return re:GetHandler()==e:GetHandler() and g:GetCount()>0
end
function scard.tgtg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		--chain limit
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_CANNOT_TRIGGER)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e1,true)
	end
end
function scard.tgop2(e,tp,eg,ep,ev,re,r,rp)
	Duel.DMSendtoGrave(e:GetLabelObject(),REASON_EFFECT)
end
