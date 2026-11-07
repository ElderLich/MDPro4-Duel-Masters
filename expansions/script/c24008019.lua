--Grape Globbo
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.ConfirmOperation(PLAYER_SELF,aux.NOT(Card.IsPublic),0,LOCATION_HAND))
end
scard.duel_masters_card=true
