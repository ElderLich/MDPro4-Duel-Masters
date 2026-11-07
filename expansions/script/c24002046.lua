--Elf-X
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cost down
	dm.EnableUpdatePlayCost(c,-1,LOCATION_ALL,0,aux.TargetBoolFunction(Card.IsCreature))
end
scard.duel_masters_card=true
