--Plasma Chaser
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.drtg,scard.drop)
end
scard.duel_masters_card=true
function scard.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,DM_LOCATION_BZONE,nil)>0 end
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,DM_LOCATION_BZONE,nil)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
