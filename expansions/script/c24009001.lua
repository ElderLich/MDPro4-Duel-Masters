--Glena Vuele, the Hypnotic
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GUARDIAN))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--to shield zone
	dm.AddTriggerEffectPlayerUseShieldTrigger(c,0,PLAYER_OPPO,true,scard.tstg,scard.tsop)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_GUARDIAN}
scard.tstg=dm.DecktopSendtoSZoneTarget(PLAYER_SELF)
scard.tsop=dm.DecktopSendtoSZoneOperation(PLAYER_SELF,1)
