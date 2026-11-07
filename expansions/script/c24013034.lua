--剛勇傀儡ガシガシ
--Gashi Gashi, the Brave Puppet
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--send replace (to mana zone)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_BATTLED)
	e1:SetCondition(scard.tmcon1)
	e1:SetOperation(scard.tmop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_CUSTOM+DM_EVENT_LOSE_BATTLE)
	e2:SetCondition(scard.tmcon2)
	c:RegisterEffect(e2)
end
scard.duel_masters_card=true
function scard.tmcon1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	local g=Group.FromCards(c,bc)
	g:KeepAlive()
	e:SetLabelObject(g)
	return c:IsStatus(STATUS_BATTLE_DESTROYED) and bc and bc:IsStatus(STATUS_OPPO_BATTLE)
end
function scard.tmcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Group.FromCards(c,c:GetBattleTarget())
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SendtoMZone(e:GetLabelObject(),POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
--[[
	References
		1. Dark Magician of Chaos
		https://github.com/Fluorohydride/ygopro-scripts/blob/a0db0e4/c40737112.lua#L21
		2. Neo-Spacian Grand Mole
		https://github.com/Fluorohydride/ygopro-scripts/blob/6324c1c/c80344569.lua#L16
]]
