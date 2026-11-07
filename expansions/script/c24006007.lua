--Invincible Cataclysm
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to grave
	dm.AddSpellCastEffect(c,0,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.tgtg=dm.TargetCardFunction(PLAYER_SELF,dm.ShieldZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_SZONE,0,3,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetCardsOperation(Duel.DMSendtoGrave,REASON_EFFECT)
