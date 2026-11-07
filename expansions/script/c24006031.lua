--Aqua Rider
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddTriggerEffect(c,0,DM_EVENT_SUMMON,nil,nil,scard.abop,nil,scard.abcon)
	dm.AddTriggerEffectPlayerCastSpell(c,0,PLAYER_OPPO,nil,nil,nil,scard.abop)
end
scard.duel_masters_card=true
scard.abcon=dm.PlayerSummonCreatureCondition(PLAYER_OPPO)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	--blocker
	dm.RegisterEffectBlocker(c,c,1)
end
