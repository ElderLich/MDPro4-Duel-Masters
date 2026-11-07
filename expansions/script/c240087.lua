--Super Dragon Machine Dolzark
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana zone
	dm.AddTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.tmtg,scard.tmop,EFFECT_FLAG_CARD_TARGET,scard.tmcon)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.tmcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(tp) and a:DMIsRace(DM_RACE_DRAGON) and a~=e:GetHandler()
end
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(5000) and c:IsAbleToMZone()
end
scard.tmtg=dm.TargetCardFunction(PLAYER_SELF,scard.tmfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TOMZONE)
scard.tmop=dm.TargetCardsOperation(Duel.SendtoMZone,POS_FACEUP_UNTAPPED,REASON_EFFECT)
