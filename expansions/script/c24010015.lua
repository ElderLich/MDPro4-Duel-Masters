--Flohdani, the Spydroid
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--silent skill (tap)
	dm.EnableSilentSkill(c,0,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsAbleToTap()
end
scard.postg=dm.TargetCardFunction(PLAYER_SELF,scard.posfilter,0,DM_LOCATION_BZONE,1,2,DM_HINTMSG_TAP)
scard.posop=dm.TargetCardsOperation(Duel.Tap,REASON_EFFECT)
