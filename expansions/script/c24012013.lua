--Mechadragon's Breath
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(6000)
end
function scard.desfilter(c,pwr)
	return c:IsFaceup() and c:IsPower(pwr)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(scard.cfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil)
	if g1:GetCount()==0 then return end
	local ag=Group.CreateGroup()
	local power_list={}
	for tc in aux.Next(g1) do
		local pwr=tc:GetPower()
		if not ag:IsExists(Card.IsPower,1,nil,pwr) then
			ag:AddCard(tc)
			table.insert(power_list,pwr)
		end
	end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_NUMBER)
	local an=Duel.AnnounceNumber(tp,table.unpack(power_list))
	local g2=Duel.GetMatchingGroup(scard.desfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil,an)
	Duel.Destroy(g2,REASON_EFFECT)
end
