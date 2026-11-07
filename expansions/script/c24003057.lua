--Chaos Fish
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
	--draw
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.drtg,scard.drop)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_WATER)
end
--power up
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(scard.cfilter,c:GetControler(),DM_LOCATION_BZONE,0,c)*1000
end
--draw
function scard.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BZONE,0,e:GetHandler())>0 end
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BZONE,0,e:GetHandler())
	Duel.Draw(tp,ct,REASON_EFFECT)
end
