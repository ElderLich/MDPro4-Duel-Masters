--Rocketdive Skyterror
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be attacked
	dm.EnableCannotBeAttacked(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--power attacker
	dm.EnablePowerAttacker(c,1000)
end
scard.duel_masters_card=true
