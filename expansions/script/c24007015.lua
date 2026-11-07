--Rondobil, the Explorer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (to shield zone)
	dm.EnableTapAbility(c,0,nil,dm.SendtoSZoneOperation(PLAYER_SELF,Card.IsFaceup,DM_LOCATION_BZONE,0,1))
end
scard.duel_masters_card=true
