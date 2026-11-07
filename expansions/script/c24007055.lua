--World Tree, Root of Life
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_TREE_FOLK))
	--power attacker
	dm.EnablePowerAttacker(c,2000)
	--stealth (darkness)
	dm.EnableStealth(c,DM_CIVILIZATION_DARKNESS)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_TREE_FOLK}
