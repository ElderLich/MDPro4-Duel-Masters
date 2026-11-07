--Elf-X
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cost down
	dm.EnableUpdatePlayCost(c,-1,LOCATION_ALL,0,aux.TargetBoolFunction(Card.IsCreature))
end
scard.duel_masters_card=true
