--Frantic Chieftain
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.SendtoHandOperation(PLAYER_SELF,scard.retfilter,DM_LOCATION_BZONE,0,1))
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsFaceup() and c:IsManaCostBelow(4)
end
