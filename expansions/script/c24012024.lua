--Enigmatic Cascade
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--discard, draw
	dm.AddSpellCastEffect(c,0,nil,scard.dhop)
end
scard.duel_masters_card=true
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,e:GetHandler())
	local ct2=Duel.DiscardHand(tp,aux.TRUE,0,ct1,REASON_EFFECT,e:GetHandler())
	if ct2==0 then return end
	Duel.BreakEffect()
	Duel.Draw(tp,ct2,REASON_EFFECT)
end
