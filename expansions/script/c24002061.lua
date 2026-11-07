--ディープ・オペレーション
--Deep Operation
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
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,DM_LOCATION_BZONE,nil)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
