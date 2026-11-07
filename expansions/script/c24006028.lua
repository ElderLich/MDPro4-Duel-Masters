--Telitol, the Explorer
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--confirm
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.conftg,scard.confop)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
scard.conftg=dm.CheckCardFunction(dm.ShieldZoneFilter(Card.IsFacedown),DM_LOCATION_SZONE,0)
scard.confop=dm.ConfirmOperation(PLAYER_SELF,dm.ShieldZoneFilter(Card.IsFacedown),DM_LOCATION_SZONE,0)
