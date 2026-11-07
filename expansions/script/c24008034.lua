--Scream Slicer, Shadow of Fear
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.desop,nil,scard.descon)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:DMIsRace(DM_RACE_DRAGO_NOID,DM_RACE_DRAGON)
end
function scard.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,e:GetHandler(),tp)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil)
	if g:GetCount()==0 then return end
	local dg=g:GetMinGroup(Card.GetPower)
	if dg:GetCount()>1 then
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
		local sg=dg:Select(tp,1,1,nil)
		Duel.HintSelection(sg)
		Duel.Destroy(sg,REASON_EFFECT)
	else
		Duel.Destroy(dg,REASON_EFFECT)
	end
end
--[[
	References
		1. Chthonian Blast
		https://github.com/Fluorohydride/ygopro-scripts/blob/13bb48a/c18271561.lua#L31
]]
