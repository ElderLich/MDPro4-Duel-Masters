--Dyno Mantis, the Mightspinner
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GIANT_INSECT))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability (break extra shield)
	dm.EnableEffectCustom(c,DM_EFFECT_BREAK_EXTRA_SHIELD,nil,DM_LOCATION_BZONE,0,dm.TargetBoolFunctionExceptSelf(Card.IsPowerAbove,5000))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_GIANT_INSECT,DM_RACE_GIANT}
