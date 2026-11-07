--Elixia, Pureblade Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.dbcon)
	dm.AddEffectDescription(c,0,scard.dbcon)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER,scard.tbcon)
	dm.AddEffectDescription(c,1,scard.tbcon)
end
scard.duel_masters_card=true
--power up
function scard.powval(e,c)
	local g=Duel.GetMatchingGroup(dm.ManaZoneFilter(),c:GetControler(),DM_LOCATION_MZONE,0,nil)
	local ct=g:GetClassCount(Card.GetCivilization)
	return ct*3000
end
--double breaker
function scard.dbcon(e)
	return e:GetHandler():IsPowerAbove(6000)
end
--triple breaker
function scard.tbcon(e)
	return e:GetHandler():IsPowerAbove(15000)
end
--[[
	References
		1. Performapal Dramatic Theater
		https://github.com/Fluorohydride/ygopro-scripts/blob/d35f462/c55553602.lua#L32
]]
