--Estol, Vizier of Aqua
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to shield zone, confirm
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.tsop)
end
scard.duel_masters_card=true
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendDecktoptoSZone(tp,1)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_CONFIRM)
	local g=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(Card.IsFacedown),tp,0,DM_LOCATION_SZONE,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.HintSelection(g)
	Duel.ConfirmCards(tp,g)
end
