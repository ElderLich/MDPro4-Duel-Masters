--Aeris, Flight Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--attack untapped
	dm.EnableAttackUntapped(c,DM_CIVILIZATION_DARKNESS)
end
scard.duel_masters_card=true
