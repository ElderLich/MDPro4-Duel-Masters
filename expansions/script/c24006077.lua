--Cocco Lupia
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cost down
	dm.EnableUpdatePlayCost(c,-2,LOCATION_ALL,0,aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_DRAGON))
end
scard.duel_masters_card=true
