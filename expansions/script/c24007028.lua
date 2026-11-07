--Gigabuster
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--to hand
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,scard.thtg,scard.thop,EFFECT_FLAG_CARD_TARGET)
	--cannot attack
	dm.EnableCannotAttack(c)
end
scard.duel_masters_card=true
scard.thtg=dm.TargetCardFunction(PLAYER_SELF,dm.ShieldZoneFilter(Card.IsAbleToHand),DM_LOCATION_SZONE,0,1,1,DM_HINTMSG_ATOHAND)
scard.thop=dm.TargetSendtoHandOperation()
