--Cloned Nightmare
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--discard
	dm.AddSpellCastEffect(c,0,scard.dhtg,scard.dhop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.dhfilter(c,e)
	return c:IsCanBeEffectTarget(e)
end
function scard.dhtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	local g=Duel.GetMatchingGroup(scard.dhfilter,tp,0,LOCATION_HAND,nil,e)
	local sg1=g:RandomSelect(tp,1)
	Duel.SetTargetCard(sg1)
	g:Sub(sg1)
	local ct=Duel.GetMatchingGroupCount(dm.DMGraveFilter(Card.IsCode),tp,DM_LOCATION_GRAVE,DM_LOCATION_GRAVE,nil,CARD_CLONED_NIGHTMARE)
	if g:GetCount()==0 or ct==0 then return end
	local sg2=g:RandomSelect(tp,0,ct)
	Duel.SetTargetCard(sg2)
end
scard.dhop=dm.TargetCardsOperation(Duel.DMSendtoGrave,REASON_EFFECT+REASON_DISCARD)
