--Bolmeteus Steel Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--break replace (to grave)
	dm.AddReplaceEffectBreakShield(c,DM_LOCATION_GRAVE)
end
scard.duel_masters_card=true
