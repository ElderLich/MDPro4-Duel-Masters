--Schuka, Duke of Amnesia
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard
	dm.AddSingleTriggerEffect(c,0,EVENT_DESTROYED,nil,nil,dm.DiscardOperation(nil,aux.TRUE,LOCATION_HAND,LOCATION_HAND))
end
scard.duel_masters_card=true
