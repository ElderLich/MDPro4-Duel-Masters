--Midnight Crawler
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.rettg=dm.TargetCardFunction(PLAYER_SELF,dm.ManaZoneFilter(Card.IsAbleToHand),0,DM_LOCATION_MZONE,1,1,DM_HINTMSG_RTOHAND)
scard.retop=dm.TargetSendtoHandOperation()
