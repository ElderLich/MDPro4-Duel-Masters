--Brigade Shell Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (confirm) (to hand or to grave)
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,dm.HintTarget,scard.thop)
	dm.AddSingleGrantTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,dm.HintTarget,scard.thop,nil,LOCATION_ALL,0,scard.thtg)
end
scard.duel_masters_card=true
function scard.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)==0 then return end
	Duel.ConfirmDecktop(tp,1)
	local tc=Duel.GetDecktopGroup(tp,1):GetFirst()
	Duel.DisableShuffleCheck()
	if tc:DMIsRace(DM_RACE_SURVIVOR) and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,PLAYER_OWNER,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
		Duel.ShuffleHand(tp)
	else
		Duel.DMSendtoGrave(tc,REASON_EFFECT)
	end
end
scard.thtg=dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_SURVIVOR)
