--Kelp Candle
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack
	dm.EnableCannotAttack(c)
	--to hand
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_BATTLE_END,nil,nil,scard.thop,nil,dm.SelfBlockCondition)
end
scard.duel_masters_card=true
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	local g=Duel.GetDecktopGroup(tp,4)
	Duel.ConfirmCards(tp,g)
	if g:IsExists(Card.IsAbleToHand,1,nil) then
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_ATOHAND)
		local sg=g:FilterSelect(tp,Card.IsAbleToHand,1,1,nil)
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)
		Duel.ShuffleHand(tp)
		dm.SortDeck(tp,tp,3,DECK_SEQUENCE_BOTTOM)
	else dm.SortDeck(tp,tp,4,DECK_SEQUENCE_BOTTOM) end
end
--[[
	References
		1. Dark Magical Circle
		https://github.com/Fluorohydride/ygopro-scripts/blob/cb54f7a/c47222536.lua#L38
		2. World Legacy Survivor
		https://github.com/Fluorohydride/ygopro-scripts/blob/97e53fe/c31706048.lua#L24
]]
