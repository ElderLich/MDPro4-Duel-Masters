--Laser Whip
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--tap, get ability
	dm.AddSpellCastEffect(c,0,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.posfilter(c)
	return c:IsFaceup() and c:IsAbleToTap()
end
scard.postg=dm.TargetCardFunction(PLAYER_SELF,scard.posfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TAP)
function scard.abfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and scard.posfilter(tc) then
		Duel.Tap(tc,REASON_EFFECT)
	end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,scard.abfilter,tp,DM_LOCATION_BZONE,0,0,1,nil,e)
	if g:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.SetTargetCard(g)
	--cannot be blocked
	dm.RegisterEffectCannotBeBlocked(e:GetHandler(),g:GetFirst(),1)
end
