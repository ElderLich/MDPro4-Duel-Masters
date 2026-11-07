--Divine Riptide
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--return
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoHandOperation(nil,dm.ManaZoneFilter(),DM_LOCATION_MZONE,DM_LOCATION_MZONE))
end
scard.duel_masters_card=true
