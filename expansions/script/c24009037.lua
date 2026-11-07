--Blizzard of Spears
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy
	dm.AddSpellCastEffect(c,0,nil,dm.DestroyOperation(nil,scard.desfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE))
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(4000)
end
