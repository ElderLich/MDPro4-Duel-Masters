--Kyuroro
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--change shield break player
	dm.EnablePlayerEffectCustom(c,DM_EFFECT_CHANGE_SHIELD_BREAK_PLAYER,1,0)
end
scard.duel_masters_card=true
