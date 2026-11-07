--Bliss Totem, Avatar of Luck
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (to mana zone)
	dm.EnableTapAbility(c,0,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
scard.tmtg=dm.CheckCardFunction(dm.DMGraveFilter(Card.IsAbleToMZone),DM_LOCATION_GRAVE,0)
scard.tmop=dm.SendtoMZoneOperation(PLAYER_SELF,dm.DMGraveFilter(),DM_LOCATION_GRAVE,0,0,3)
