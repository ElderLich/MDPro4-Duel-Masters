--Mummy Wrap, Shadow of Fatigue
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (discard)
	dm.EnableTapAbility(c,0,scard.dhtg,scard.dhop)
end
scard.duel_masters_card=true
scard.dhtg=dm.CheckCardFunction(aux.TRUE,LOCATION_HAND,LOCATION_HAND)
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RandomDiscardHand(tp,1,REASON_EFFECT)
	Duel.RandomDiscardHand(1-tp,1,REASON_EFFECT)
end
