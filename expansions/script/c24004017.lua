--Screaming Sunburst
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--tap
	dm.AddSpellCastEffect(c,0,nil,dm.TapOperation(nil,scard.posfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE))
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and not c:IsCivilization(DM_CIVILIZATION_LIGHT)
end
