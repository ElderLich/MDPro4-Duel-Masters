--Intense Evil
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--destroy, draw
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,DM_LOCATION_BZONE,0,0,ct1,nil)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	local ct2=Duel.Destroy(g,REASON_EFFECT)
	Duel.BreakEffect()
	Duel.Draw(tp,ct2,REASON_EFFECT)
end
