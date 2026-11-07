--バイバイ・アメーバ
--Bye Bye Amoeba
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(DM_EVENT_BATTLE_END)
	e1:SetRange(DM_LOCATION_BZONE)
	e1:SetCondition(scard.retcon)
	e1:SetOperation(scard.retop)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.retcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==e:GetHandler()
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetAttacker()
	if tc:IsRelateToBattle() then
		Duel.SendtoHand(tc,PLAYER_OWNER,REASON_EFFECT)
	end
end
--[[
	References
		1. Jurrac Ptera
		https://github.com/Fluorohydride/ygopro-scripts/blob/master/c45711266.lua
]]
