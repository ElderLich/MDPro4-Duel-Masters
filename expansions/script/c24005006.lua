--Ballus, Dogfight Enforcer Q
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (untap)
	dm.AddTriggerEffect(c,0,EVENT_PHASE+PHASE_END,nil,dm.HintTarget,scard.posop,nil,scard.poscon)
	dm.AddGrantTriggerEffect(c,0,EVENT_PHASE+PHASE_END,nil,dm.HintTarget,scard.posop,nil,LOCATION_ALL,0,scard.postg,scard.poscon)
end
scard.duel_masters_card=true
scard.poscon=aux.AND(dm.SelfTappedCondition,dm.TurnPlayerCondition(PLAYER_SELF))
scard.posop=dm.SelfUntapOperation()
scard.postg=dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_SURVIVOR)
