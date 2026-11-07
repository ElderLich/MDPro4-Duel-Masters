--Badlands Lizard
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,3000)
	--no battle
	dm.EnableEffectCustom(c,DM_EFFECT_NO_BE_BLOCKED_BATTLE)
end
scard.duel_masters_card=true
