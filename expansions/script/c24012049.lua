--Hypersprint Warrior Uzesol
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--power attacker
	dm.EnablePowerAttacker(c,4000)
end
scard.duel_masters_card=true
