--Whip Scorpion
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--power attacker
	dm.EnablePowerAttacker(c,3000)
end
scard.duel_masters_card=true
