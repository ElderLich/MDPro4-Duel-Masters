--Loth Rix, the Iridescent
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GUARDIAN))
	--to shield zone
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.DecktopSendtoSZoneOperation(PLAYER_SELF,1))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_GUARDIAN}
