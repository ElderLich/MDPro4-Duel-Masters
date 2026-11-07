--Milieus, the Daystretcher
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cost up
	dm.EnableUpdatePlayCost(c,2,LOCATION_ALL,0,scard.costtg1)
	dm.EnableUpdatePlayCost(c,2,LOCATION_ALL,0,scard.costtg2)
end
scard.duel_masters_card=true
function scard.costtg1(e,c)
	return c:IsCreature() and c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
function scard.costtg2(e,c)
	return c:IsSpell() and c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
