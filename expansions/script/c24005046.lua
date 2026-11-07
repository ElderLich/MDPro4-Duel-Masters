--Ambush Scorpion
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,3000)
	--to battle zone
	dm.AddSingleTriggerEffect(c,0,EVENT_DESTROYED,true,scard.tbtg,scard.tbop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tbfilter(c)
	return c:IsCode(CARD_AMBUSH_SCORPION)
end
scard.tbtg=dm.TargetCardFunction(PLAYER_SELF,dm.ManaZoneFilter(scard.tbfilter),DM_LOCATION_MZONE,0,1,1,DM_HINTMSG_TOBZONE)
scard.tbop=dm.TargetSendtoBZoneOperation(PLAYER_SELF,POS_FACEUP_UNTAPPED)
