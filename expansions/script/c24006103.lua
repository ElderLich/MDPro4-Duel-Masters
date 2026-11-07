--Innocent Hunter, Blade of All
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution any race
	dm.EnableEffectCustom(c,DM_EFFECT_EVOLUTION_ANY_RACE)
end
scard.duel_masters_card=true
