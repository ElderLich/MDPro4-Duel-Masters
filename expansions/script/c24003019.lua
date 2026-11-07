--Liquid Scope
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--confirm
	dm.AddSpellCastEffect(c,0,nil,dm.ConfirmOperation(PLAYER_SELF,scard.conffilter,0,LOCATION_HAND+DM_LOCATION_SZONE))
end
scard.duel_masters_card=true
function scard.conffilter(c)
	return (c:IsShield() and c:IsFacedown()) or (c:IsLocation(LOCATION_HAND) and not c:IsPublic())
end
