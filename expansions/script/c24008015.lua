--Thrumiss, Zephyr Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap
	dm.AddTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET,scard.poscon)
end
scard.duel_masters_card=true
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttacker():IsControler(tp)
end
function scard.posfilter(c)
	return c:IsFaceup() and c:IsAbleToTap()
end
scard.postg=dm.TargetCardFunction(PLAYER_SELF,scard.posfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TAP)
scard.posop=dm.TargetCardsOperation(Duel.Tap,REASON_EFFECT)
