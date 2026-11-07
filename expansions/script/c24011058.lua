--Miraculous Plague
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--return, destroy, to grave
	dm.AddSpellCastEffect(c,0,nil,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.filter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function scard.retfilter1(c,e)
	return scard.filter(c,e) and c:IsAbleToHand()
end
function scard.retfilter2(c,e)
	return c:IsAbleToHand() and c:IsCanBeEffectTarget(e)
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TARGET)
	local g1=Duel.SelectMatchingCard(tp,scard.filter,tp,0,DM_LOCATION_BZONE,2,2,nil,e)
	if g1:GetCount()>0 then
		Duel.SetTargetCard(g1)
		Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_RTOHAND)
		local g2=g1:FilterSelect(1-tp,scard.retfilter1,1,1,nil,e)
		Duel.SetTargetCard(g2)
		Duel.SendtoHand(g2,PLAYER_OWNER,REASON_EFFECT)
		g1:Sub(g2)
		Duel.Destroy(g1,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TARGET)
	local g3=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(Card.IsCanBeEffectTarget),tp,0,DM_LOCATION_MZONE,2,2,nil,e)
	if g3:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SetTargetCard(g3)
		Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_RTOHAND)
		local g4=g3:FilterSelect(1-tp,scard.retfilter2,1,1,nil,e)
		Duel.SetTargetCard(g4)
		Duel.SendtoHand(g4,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(tp,g4)
		g3:Sub(g4)
		Duel.DMSendtoGrave(g3,REASON_EFFECT)
	end
end
