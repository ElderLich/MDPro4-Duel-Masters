--ナイトメア・マシーン
--Nightmare Machine
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--destroy
	dm.AddSpellCastEffect(c,0,nil,scard.desop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.desfilter1(c)
	return c:IsFaceup() and c:IsUntapped()
end
function scard.desfilter2(c,e)
	return scard.desfilter1(c) and c:IsCanBeEffectTarget(e)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
	local g1=Duel.SelectMatchingCard(tp,scard.desfilter1,tp,DM_LOCATION_BZONE,0,1,1,nil)
	if g1:GetCount()>0 then
		Duel.HintSelection(g1)
		Duel.Destroy(g1,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_DESTROY)
	local g2=Duel.SelectMatchingCard(1-tp,scard.desfilter2,1-tp,DM_LOCATION_BZONE,0,1,1,nil,e)
	if g2:GetCount()>0 then
		Duel.BreakEffect()
		Duel.SetTargetCard(g2)
		Duel.Destroy(g2,REASON_EFFECT)
	end
end
