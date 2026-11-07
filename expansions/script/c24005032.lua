--Skullsweeper Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (discard)
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,scard.dhtg1,scard.dhop,EFFECT_FLAG_CARD_TARGET)
	dm.AddSingleGrantTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,scard.dhtg1,scard.dhop,EFFECT_FLAG_CARD_TARGET,LOCATION_ALL,0,scard.dhtg2)
end
scard.duel_masters_card=true
function scard.dhtg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_HAND) and chkc:IsControler(1-tp) end
	if chk==0 then return true end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_DISCARD)
	Duel.SelectTarget(1-tp,aux.TRUE,1-tp,LOCATION_HAND,0,1,1,nil)
end
scard.dhop=dm.TargetCardsOperation(Duel.DMSendtoGrave,REASON_EFFECT+REASON_DISCARD)
scard.dhtg2=dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_SURVIVOR)
