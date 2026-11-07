--アストラル・リーフ
--Astral Reef
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CYBER_VIRUS))
	--draw
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,dm.DrawTarget(PLAYER_SELF),dm.DrawOperation(PLAYER_SELF,3))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_CYBER_VIRUS,DM_RACE_CYBER}
