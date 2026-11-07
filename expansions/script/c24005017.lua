--Divine Riptide
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--return
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoHandOperation(nil,dm.ManaZoneFilter(),DM_LOCATION_MZONE,DM_LOCATION_MZONE))
end
scard.duel_masters_card=true
