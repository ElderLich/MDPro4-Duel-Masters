--Gabzagul, Warlord of Pain
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (must attack)
	dm.EnableEffectCustom(c,EFFECT_MUST_ATTACK,nil,DM_LOCATION_BZONE,DM_LOCATION_BZONE)
end
scard.duel_masters_card=true
