--Snork La, Shrine Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--return
	dm.AddTriggerEffect(c,0,DM_EVENT_TO_GRAVE,true,scard.rettg,scard.retop,nil,scard.retcon)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsControler(tp) and dm.PreviousLocationMZoneFilter(c)
end
function scard.retcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(dm.DMGraveFilter(scard.cfilter),1,nil,tp) and rp==1-tp
end
function scard.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(Card.IsAbleToMZone,1,nil) end
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoMZone(eg,POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
