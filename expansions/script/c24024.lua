--無規律の超人 (エントロピー・ジャイアント)
--Entropy Giant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--untap
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_ATTACK_END,nil,nil,dm.SelfUntapOperation(true),nil,dm.SelfAttackerCondition)
end
scard.duel_masters_card=true
