--Mini Titan Gett
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--must attack
	dm.EnableEffectCustom(c,EFFECT_MUST_ATTACK)
	--power attacker
	dm.EnablePowerAttacker(c,1000)
end
scard.duel_masters_card=true
