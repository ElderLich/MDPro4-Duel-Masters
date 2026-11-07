--Lockdown Lizard
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot use tap ability
	dm.EnablePlayerEffectCustom(c,DM_EFFECT_CANNOT_USE_TAP_ABILITY,1,1)
end
scard.duel_masters_card=true
