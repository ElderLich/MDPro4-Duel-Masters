--Cyclone Panic
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--draw
	dm.AddSpellCastEffect(c,0,nil,scard.drop)
end
scard.duel_masters_card=true
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(tp,LOCATION_HAND,LOCATION_HAND)
	g:RemoveCard(e:GetHandler())
	if Duel.SendtoDeck(g,PLAYER_OWNER,DECK_SEQUENCE_TOP,REASON_EFFECT)==0 then return end
	local og=g:Filter(Card.IsLocation,nil,LOCATION_DECK)
	Duel.ShuffleDeck(tp)
	Duel.ShuffleDeck(1-tp)
	local ct1=og:FilterCount(aux.FilterEqualFunction(Card.GetPreviousControler,tp),nil)
	local ct2=og:FilterCount(aux.FilterEqualFunction(Card.GetPreviousControler,1-tp),nil)
	Duel.BreakEffect()
	Duel.Draw(tp,ct1,REASON_EFFECT)
	Duel.Draw(1-tp,ct2,REASON_EFFECT)
end
