--Aurora of Reversal
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana zone
	dm.AddSpellCastEffect(c,0,nil,scard.tmop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tmfilter(c,e)
	return c:IsAbleToMZone() and c:IsCanBeEffectTarget(e)
end
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(dm.ShieldZoneFilter(scard.tmfilter),tp,DM_LOCATION_SZONE,0,nil,e)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOMZONE)
	local g=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(scard.tmfilter),tp,DM_LOCATION_SZONE,0,0,ct,nil,e)
	if g:GetCount()==0 then return end
	Duel.SetTargetCard(g)
	Duel.SendtoMZone(g,POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
