--Stinger Horn, the Delver
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,1000)
	--stealth (water)
	dm.EnableStealth(c,DM_CIVILIZATION_WATER)
end
scard.duel_masters_card=true
