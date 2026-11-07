--Mega Detonator
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.abfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct1=Duel.GetMatchingGroupCount(aux.TRUE,tp,LOCATION_HAND,0,c)
	local ct2=Duel.DiscardHand(tp,aux.TRUE,0,ct1,REASON_EFFECT,c)
	if ct2==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TARGET)
	local g=Duel.SelectMatchingCard(tp,scard.abfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,ct2,ct2,nil,e)
	if g:GetCount()==0 then return end
	Duel.SetTargetCard(g)
	for tc in aux.Next(g) do
		--double breaker
		dm.RegisterEffectBreaker(c,tc,1,DM_EFFECT_DOUBLE_BREAKER)
	end
end
