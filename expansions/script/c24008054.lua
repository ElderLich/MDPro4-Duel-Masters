--Terradragon Gamiratar
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to battle zone
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,scard.tbtg,scard.tbop,EFFECT_FLAG_CARD_TARGET)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.tbtg=dm.TargetCardFunction(PLAYER_OPPO,nil,0,LOCATION_HAND,0,1,DM_HINTMSG_TOBZONE)
scard.tbop=dm.TargetSendtoBZoneOperation(PLAYER_OPPO,POS_FACEUP_UNTAPPED)
