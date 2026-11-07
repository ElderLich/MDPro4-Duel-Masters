--天使と悪魔の墳墓
--The Grave of Angels and Demons
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--destroy, to grave
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c,g)
	local code=c:GetCode()
	return g:IsExists(Card.IsCode,1,c,code)
end
function scard.tgfilter(c,g)
	local code=c:GetCode()
	return g:IsExists(Card.IsCode,1,c,code) and c:DMIsAbleToGrave()
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil)
	local dg=g1:Filter(scard.desfilter,nil,g1)
	Duel.Destroy(dg,REASON_EFFECT)
	local g2=Duel.GetMatchingGroup(dm.ManaZoneFilter(),tp,DM_LOCATION_MZONE,DM_LOCATION_MZONE,nil)
	local tg=g2:Filter(scard.tgfilter,nil,g2)
	Duel.BreakEffect()
	Duel.DMSendtoGrave(tg,REASON_EFFECT)
end
--[[
	References
		1. Kotodama
		https://github.com/Fluorohydride/ygopro-scripts/blob/master/c19406822.lua
]]
