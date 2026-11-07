--Bat Doctor, Shadow of Undeath
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	local targ_func=dm.CheckCardFunction(dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0,c)
	local op_func=dm.SendtoHandOperation(PLAYER_SELF,dm.DMGraveFilter(Card.IsCreature),DM_LOCATION_GRAVE,0,1,1,true,c)
	dm.AddSingleTriggerEffect(c,0,EVENT_DESTROYED,true,targ_func,op_func)
end
scard.duel_masters_card=true
function scard.retfilter(c)
	return c:IsCreature() and c:IsAbleToHand()
end
