--神楽妖精パルティア
--Parthia, Dancing Faerie
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to deck
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,scard.tdtg,scard.tdop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.tdtg=dm.TargetCardFunction(PLAYER_SELF,dm.DMGraveFilter(Card.IsAbleToDeck),DM_LOCATION_GRAVE,0,0,3,DM_HINTMSG_TODECK)
scard.tdop=dm.TargetCardsOperation(Duel.SendtoDeck,PLAYER_OWNER,DECK_SEQUENCE_SHUFFLE,REASON_EFFECT)
