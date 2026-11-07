--Ancient Horn, the Watcher
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--untap
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.posop,nil,scard.poscon)
end
scard.duel_masters_card=true
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetShieldCount(tp)>=5
end
scard.posop=dm.UntapOperation(nil,dm.ManaZoneFilter(),DM_LOCATION_MZONE,0)
