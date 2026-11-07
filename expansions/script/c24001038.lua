--Saucer-Head Shark
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.SendtoHandOperation(nil,scard.retfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE))
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(2000)
end
