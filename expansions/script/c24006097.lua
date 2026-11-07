--Factory Shell Q
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (search) (to hand)
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,dm.HintTarget,scard.thop)
	dm.AddSingleGrantTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,dm.HintTarget,scard.thop,nil,LOCATION_ALL,0,scard.thtg)
end
scard.duel_masters_card=true
function scard.thfilter(c)
	return c:DMIsRace(DM_RACE_SURVIVOR)
end
scard.thop=dm.SendtoHandOperation(PLAYER_SELF,scard.thfilter,LOCATION_DECK,0,0,1,true)
scard.thtg=dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_SURVIVOR)
