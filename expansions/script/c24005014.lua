--Syforce, Aurora Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--return
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.rettg,scard.retop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsSpell() and c:IsAbleToHand()
end
scard.rettg=dm.CheckCardFunction(dm.ManaZoneFilter(scard.retfilter),DM_LOCATION_MZONE,0)
scard.retop=dm.SendtoHandOperation(PLAYER_SELF,dm.ManaZoneFilter(Card.IsSpell),DM_LOCATION_MZONE,0,1)
