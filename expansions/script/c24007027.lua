--Gezary, Undercover Doll
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--stealth (nature)
	dm.EnableStealth(c,DM_CIVILIZATION_NATURE)
end
scard.duel_masters_card=true
