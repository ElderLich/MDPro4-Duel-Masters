--Miraculous Snare
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to shield zone
	dm.AddSpellCastEffect(c,0,scard.tstg,scard.tsop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tsfilter(c)
	return c:IsFaceup() and not c:IsEvolution() and c:IsAbleToSZone()
end
scard.tstg=dm.TargetCardFunction(PLAYER_SELF,scard.tsfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TOSZONE)
scard.tsop=dm.TargetSendtoSZoneOperation
