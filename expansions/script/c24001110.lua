--Ultimate Force
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana zone
	dm.AddSpellCastEffect(c,0,nil,dm.DecktopSendtoMZoneOperation(PLAYER_SELF,2))
end
scard.duel_masters_card=true
