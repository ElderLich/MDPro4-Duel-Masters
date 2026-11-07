--Adomis, the Oracle
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (confirm)
	dm.EnableTapAbility(c,0,scard.conftg,scard.confop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.conftg=dm.TargetCardFunction(PLAYER_SELF,dm.ShieldZoneFilter(Card.IsFacedown),DM_LOCATION_SZONE,DM_LOCATION_SZONE,0,1,DM_HINTMSG_CONFIRM)
scard.confop=dm.TargetConfirmOperation()
