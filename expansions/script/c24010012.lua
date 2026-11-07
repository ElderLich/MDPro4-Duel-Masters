--Bulgluf, the Spydroid
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--silent skill (to shield zone)
	dm.EnableSilentSkill(c,0,dm.DecktopSendtoSZoneTarget(PLAYER_SELF),dm.DecktopSendtoSZoneOperation(PLAYER_SELF,1))
end
scard.duel_masters_card=true
