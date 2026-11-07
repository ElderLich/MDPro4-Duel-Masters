--Rodi Gale, Night Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--stealth (darkness)
	dm.EnableStealth(c,DM_CIVILIZATION_DARKNESS)
end
scard.duel_masters_card=true
