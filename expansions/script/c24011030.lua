--Roulette of Ruin
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--discard
	dm.AddSpellCastEffect(c,0,nil,scard.dhop)
end
scard.duel_masters_card=true
function scard.dhfilter(c,cost)
	return c:IsManaCost(cost)
end
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_NUMBER)
	local cost=Duel.AnnounceNumber(tp,table.unpack(dm.mana_cost_list))
	local g1=Duel.GetFieldGroup(tp,LOCATION_HAND,0)
	g1:RemoveCard(e:GetHandler())
	if g1:GetCount()>0 then
		Duel.ConfirmCards(1-tp,g1)
		local sg1=g1:Filter(scard.dhfilter,nil,cost)
		Duel.DMSendtoGrave(sg1,REASON_EFFECT+REASON_DISCARD)
	end
	local g2=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g2:GetCount()>0 then
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,g2)
		local sg2=g2:Filter(scard.dhfilter,nil,cost)
		Duel.DMSendtoGrave(sg2,REASON_EFFECT+REASON_DISCARD)
	end
end
