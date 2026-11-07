--Kolon, the Oracle
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--tap
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsAbleToTap()
end
scard.postg=dm.TargetCardFunction(PLAYER_SELF,scard.posfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TAP)
scard.posop=dm.TargetCardsOperation(Duel.Tap,REASON_EFFECT)
