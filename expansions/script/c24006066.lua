--Schuka, Duke of Amnesia
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard
	dm.AddSingleTriggerEffect(c,0,EVENT_DESTROYED,nil,nil,dm.DiscardOperation(nil,aux.TRUE,LOCATION_HAND,LOCATION_HAND))
end
scard.duel_masters_card=true
