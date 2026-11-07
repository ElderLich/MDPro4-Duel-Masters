--Rise and Shine
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--confirm (to hand)
	dm.AddSpellCastEffect(c,0,nil,scard.thop)
end
scard.duel_masters_card=true
function scard.thfilter(c)
	return c:IsHasEffect(DM_EFFECT_BLOCKER) and c:IsAbleToHand()
end
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,4)
	local g=Duel.GetDecktopGroup(tp,4)
	if g:IsExists(scard.thfilter,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,scard.thfilter,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
		Duel.ShuffleHand(tp)
		dm.SortDeck(tp,tp,3,DECK_SEQUENCE_BOTTOM)
	else dm.SortDeck(tp,tp,4,DECK_SEQUENCE_BOTTOM) end
end
