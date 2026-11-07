--Artisan Picora
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.SendtoGraveOperation(PLAYER_SELF,dm.ManaZoneFilter(),DM_LOCATION_MZONE,0,1))
end
scard.duel_masters_card=true
