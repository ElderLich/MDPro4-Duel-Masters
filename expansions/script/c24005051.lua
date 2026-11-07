--Enchanted Soil
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana zone
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoMZoneOperation(PLAYER_SELF,dm.DMGraveFilter(Card.IsCreature),DM_LOCATION_GRAVE,0,0,2))
end
scard.duel_masters_card=true
