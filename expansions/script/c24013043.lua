--爆弾人形ニヤーリ
--Niyaari, Exploding Doll
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddSingleTriggerEffect(c,0,EVENT_BE_BATTLE_TARGET,nil,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	--slayer
	dm.RegisterEffectSlayer(c,c,1)
end
