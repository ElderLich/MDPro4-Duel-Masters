--Abduction Charger
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--return
	dm.AddSpellCastEffect(c,0,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
	--charger
	dm.EnableEffectCustom(c,DM_EFFECT_CHARGER)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
scard.rettg=dm.TargetCardFunction(PLAYER_SELF,scard.retfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE,0,2,DM_HINTMSG_RTOHAND)
scard.retop=dm.TargetSendtoHandOperation()
