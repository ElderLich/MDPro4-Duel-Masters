--Wyn, the Oracle
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.conftg,scard.confop)
end
scard.duel_masters_card=true
scard.conftg=dm.CheckCardFunction(dm.ShieldZoneFilter(Card.IsFacedown),0,DM_LOCATION_SZONE)
scard.confop=dm.ConfirmOperation(PLAYER_SELF,dm.ShieldZoneFilter(Card.IsFacedown),0,DM_LOCATION_SZONE,1)
