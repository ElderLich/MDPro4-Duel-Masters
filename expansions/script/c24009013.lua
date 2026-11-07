--Nexus Charger
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to shield zone
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoSZoneOperation(PLAYER_SELF,nil,LOCATION_HAND,0,1))
	--charger
	dm.EnableEffectCustom(c,DM_EFFECT_CHARGER)
end
scard.duel_masters_card=true
