--Thorny Mandra
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana zone
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsCreature() and c:IsAbleToMZone()
end
scard.tmtg=dm.CheckCardFunction(dm.DMGraveFilter(scard.tmfilter),DM_LOCATION_GRAVE,0)
scard.tmop=dm.SendtoMZoneOperation(PLAYER_SELF,dm.DMGraveFilter(Card.IsCreature),DM_LOCATION_GRAVE,0,1)
