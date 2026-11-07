--Gigagrax
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleTriggerEffect(c,0,EVENT_DESTROYED,true,scard.destg,scard.desop)
end
scard.duel_masters_card=true
scard.destg=dm.CheckCardFunction(Card.IsFaceup,0,DM_LOCATION_BZONE)
scard.desop=dm.DestroyOperation(PLAYER_SELF,Card.IsFaceup,0,DM_LOCATION_BZONE,1)
