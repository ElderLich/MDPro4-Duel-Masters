--Benzo, the Hidden Fury
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to hand
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,scard.thtg,scard.thop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.thtg=dm.TargetCardFunction(PLAYER_SELF,dm.ShieldZoneFilter(Card.IsAbleToHand),DM_LOCATION_SZONE,0,1,1,DM_HINTMSG_ATOHAND)
scard.thop=dm.TargetSendtoHandOperation(nil,true)
