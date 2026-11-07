--Gazer Eyes, Shadow of Secrets
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--silent skill (discard)
	dm.EnableSilentSkill(c,0,scard.dhtg,scard.dhop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.dhtg=dm.CheckCardFunction(aux.TRUE,0,LOCATION_HAND)
function scard.dhfilter(c,e)
	return c:IsCanBeEffectTarget(e)
end
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,0,LOCATION_HAND)
	if g:GetCount()==0 then return end
	Duel.ConfirmCards(tp,g)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DISCARD)
	local sg=g:FilterSelect(tp,scard.dhfilter,1,1,nil,e)
	Duel.SetTargetCard(sg)
	Duel.DMSendtoGrave(sg,REASON_EFFECT+REASON_DISCARD)
	Duel.ShuffleHand(1-tp)
end
