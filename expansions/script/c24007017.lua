--Aqua Fencer
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (return)
	dm.EnableTapAbility(c,0,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.rettg=dm.TargetCardFunction(PLAYER_SELF,dm.ManaZoneFilter(Card.IsAbleToHand),0,DM_LOCATION_MZONE,1,1,DM_HINTMSG_RTOHAND)
scard.retop=dm.TargetSendtoHandOperation()
