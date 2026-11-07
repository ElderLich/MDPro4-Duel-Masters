--Ularus, Punishment Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.conftg,scard.confop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.conftg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local f=dm.ShieldZoneFilter(Card.IsFacedown)
	if chkc then return chkc:IsLocation(DM_LOCATION_SZONE) and f(chkc) end
	if chk==0 then return Duel.IsExistingTarget(f,tp,DM_LOCATION_SZONE,DM_LOCATION_SZONE,1,nil) end
	local ct=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_CONFIRM)
	Duel.SelectTarget(tp,f,tp,DM_LOCATION_SZONE,DM_LOCATION_SZONE,ct,ct,nil)
end
scard.confop=dm.TargetConfirmOperation(true)
