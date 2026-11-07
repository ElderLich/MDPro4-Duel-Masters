--予言者ポラリス
--Polaris, the Oracle
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddTriggerEffect(c,0,EVENT_BE_BATTLE_TARGET,nil,nil,scard.abop,nil,scard.abcon)
end
scard.duel_masters_card=true
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d:IsFaceup() and d:IsControler(tp)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local d=Duel.GetAttackTarget()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() or not d:IsRelateToBattle() or not d:IsFaceup() then return end
	--power up
	dm.RegisterEffectUpdatePower(c,d,1,2000,0,0)
end
