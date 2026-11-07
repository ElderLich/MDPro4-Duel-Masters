--Cranium Clamp
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--discard
	dm.AddSpellCastEffect(c,0,scard.dhtg,scard.dhop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.dhtg=dm.TargetCardFunction(PLAYER_OPPO,aux.TRUE,0,LOCATION_HAND,2,2,DM_HINTMSG_DISCARD)
scard.dhop=dm.TargetCardsOperation(Duel.DMSendtoGrave,REASON_EFFECT+REASON_DISCARD)
