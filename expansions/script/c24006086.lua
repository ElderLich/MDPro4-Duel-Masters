--Q-tronic Gargantua
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_SURVIVOR))
	--crew breaker
	dm.EnableBreaker(c,DM_EFFECT_CREW_BREAKER)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_SURVIVOR}
function scard.crew_breaker_count(c)
	local f=function(c)
		return c:IsFaceup() and c:DMIsRace(DM_RACE_SURVIVOR)
	end
	return Duel.GetMatchingGroupCount(f,c:GetControler(),DM_LOCATION_BZONE,0,c)+1
end
