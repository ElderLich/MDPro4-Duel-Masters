--Simian Warrior Grash
--Not fully implemented: If this and another creature are destroyed at the same time, you can still trigger its ability.
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddTriggerEffect(c,0,EVENT_DESTROYED,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET,scard.tgcon)
end
scard.duel_masters_card=true
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.DMIsPreviousRace,1,nil,DM_RACE_ARMORLOID)
end
function scard.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local f=dm.ManaZoneFilter(Card.DMIsAbleToGrave)
	if chkc then return chkc:IsLocation(DM_LOCATION_MZONE) and chkc:IsControler(1-tp) and f(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TOGRAVE)
	Duel.SelectTarget(1-tp,f,1-tp,DM_LOCATION_MZONE,0,eg:GetCount(),eg:GetCount(),nil)
end
scard.tgop=dm.TargetCardsOperation(Duel.DMSendtoGrave,REASON_EFFECT)
--[[
	References
		1. Performapal Sellshell Crab
		https://github.com/Fluorohydride/ygopro-scripts/blob/2c4f0ca/c23377694.lua#L68
]]
