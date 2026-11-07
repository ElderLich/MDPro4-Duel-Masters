--Bakkra Horn, the Silent
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana zone
	dm.AddTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.tmop,nil,scard.tmcon)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:DMIsRace(DM_RACE_DRAGO_NOID,DM_RACE_DRAGON)
end
function scard.tmcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,e:GetHandler(),tp)
end
scard.tmop=dm.DecktopSendtoMZoneOperation(PLAYER_SELF,1)
