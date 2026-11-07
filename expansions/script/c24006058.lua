--Grave Worm Q
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (return)
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.rettg1,scard.retop)
	dm.AddSingleGrantTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.rettg1,scard.retop,nil,LOCATION_ALL,0,scard.rettg2)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:DMIsRace(DM_RACE_SURVIVOR) and c:IsAbleToHand()
end
function scard.rettg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(dm.DMGraveFilter(scard.retfilter),tp,DM_LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
scard.retop=dm.SendtoHandOperation(PLAYER_SELF,dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0,1)
scard.rettg2=dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_SURVIVOR)
