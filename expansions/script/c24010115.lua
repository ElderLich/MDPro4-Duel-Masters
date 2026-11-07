--Core-Crash Lizard
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.tgtg=dm.TargetCardFunction(PLAYER_SELF,dm.ShieldZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_SZONE,1,1,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetCardsOperation(Duel.DMSendtoGrave,REASON_EFFECT)
