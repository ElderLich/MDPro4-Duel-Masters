--Balesk Baj, the Timeburner
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_ARMORED_WYVERN))
	--skip turn
	dm.AddSingleTriggerEffect(c,0,EVENT_BATTLE_CONFIRM,nil,nil,scard.skipop,nil,scard.skipcon)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--return
	dm.EnableTurnEndSelfReturn(c)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_ARMORED_WYVERN}
scard.skipcon=aux.AND(dm.UnblockedCondition,dm.AttackPlayerCondition)
function scard.skipop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_TURN)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetReset(RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	Duel.RegisterEffect(e1,tp)
end
