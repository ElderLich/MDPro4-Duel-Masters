--Chains of Sacrifice
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,DM_LOCATION_BZONE,0,2,nil)
	if g1:GetCount()>0 then
		Duel.HintSelection(g1)
		Duel.Destroy(g1,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,DM_LOCATION_BZONE,0,1,1,nil)
	if g2:GetCount()==0 then return end
	Duel.HintSelection(g2)
	Duel.Destroy(g2,REASON_EFFECT)
end
