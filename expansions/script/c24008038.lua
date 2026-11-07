--Kyrstron, Lair Delver
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to battle zone
	dm.AddSingleTriggerEffect(c,0,EVENT_DESTROYED,true,scard.tbtg,scard.tbop)
end
scard.duel_masters_card=true
function scard.tbfilter(c)
	return c:DMIsRace(DM_RACE_DRAGON)
end
scard.tbtg=dm.SendtoBZoneTarget(scard.tbfilter,LOCATION_HAND,0)
scard.tbop=dm.SendtoBZoneOperation(PLAYER_SELF,scard.tbfilter,LOCATION_HAND,0,1)
