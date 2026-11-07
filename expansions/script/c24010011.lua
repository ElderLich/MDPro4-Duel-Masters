--Berochika, Channeler of Suns
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to shield zone
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.tsop,nil,scard.tscon)
end
scard.duel_masters_card=true
function scard.tscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetShieldCount(tp)>=5
end
scard.tsop=dm.DecktopSendtoSZoneOperation(PLAYER_SELF,1)
