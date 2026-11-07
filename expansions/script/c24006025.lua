--Rain of Arrows
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--discard
	dm.AddSpellCastEffect(c,0,nil,scard.dhop)
end
scard.duel_masters_card=true
function scard.dhfilter(c)
	return c:IsSpell() and c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	local sg=g:Filter(scard.dhfilter,nil)
	Duel.DMSendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	Duel.ShuffleHand(1-tp)
end
