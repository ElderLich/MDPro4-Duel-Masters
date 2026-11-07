--Sundrop Armor
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to shield zone
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoSZoneOperation(PLAYER_SELF,nil,LOCATION_HAND,0,1))
end
scard.duel_masters_card=true
