--Bolshack Dragon
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval,dm.SelfAttackerCondition)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(dm.DMGraveFilter(Card.IsCivilization),c:GetControler(),DM_LOCATION_GRAVE,0,nil,DM_CIVILIZATION_FIRE)*1000
end
--[[
	References
		1. Worm Solid
		https://github.com/Fluorohydride/ygopro-scripts/blob/b81455f/c3204467.lua#L22
		2. Pilgrim Reaper
		https://github.com/Fluorohydride/ygopro-scripts/blob/2f8b6d0/c45742626.lua#L30
]]
