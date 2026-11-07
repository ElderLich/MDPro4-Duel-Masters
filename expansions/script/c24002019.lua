--Recon Operation
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--confirm
	dm.AddSpellCastEffect(c,0,nil,dm.ConfirmOperation(PLAYER_SELF,dm.ShieldZoneFilter(Card.IsFacedown),0,DM_LOCATION_SZONE,0,3))
end
scard.duel_masters_card=true
