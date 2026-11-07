--ハリケーン・フィッシュ
--Hurricane Fish
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.DrawOperation(PLAYER_SELF,1))
	--return
	dm.AddTriggerEffect(c,1,EVENT_PHASE+PHASE_END,nil,nil,scard.retop,nil,scard.retcon)
end
scard.duel_masters_card=true
scard.retcon=dm.TurnPlayerCondition(PLAYER_SELF)
function scard.retfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.retfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil):RandomSelect(tp,1)
	Duel.HintSelection(g)
	Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
end
