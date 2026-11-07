--Corile
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to deck
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,scard.tdtg,scard.tdop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tdfilter(c)
	return c:IsFaceup() and c:IsAbleToDeck()
end
scard.tdtg=dm.TargetCardFunction(PLAYER_SELF,scard.tdfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TODECK)
scard.tdop=dm.TargetCardsOperation(Duel.SendtoDeck,PLAYER_OWNER,DECK_SEQUENCE_TOP,REASON_EFFECT)
