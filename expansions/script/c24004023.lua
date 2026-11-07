--Hydro Hurricane
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--return
	dm.AddSpellCastEffect(c,0,nil,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.cfilter(c,civ)
	return c:IsFaceup() and c:IsCivilization(civ)
end
function scard.retfilter(c,e)
	return c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BZONE,0,nil,DM_CIVILIZATION_LIGHT)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g1=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(scard.retfilter),tp,0,DM_LOCATION_MZONE,0,ct1,nil,e)
	if g1:GetCount()>0 then
		Duel.SetTargetCard(g1)
		Duel.SendtoHand(g1,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(tp,g1)
	end
	local ct2=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BZONE,0,nil,DM_CIVILIZATION_DARKNESS)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g2=Duel.SelectMatchingCard(tp,scard.retfilter,tp,0,DM_LOCATION_BZONE,0,ct2,nil,e)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoHand(g2,PLAYER_OWNER,REASON_EFFECT)
end
