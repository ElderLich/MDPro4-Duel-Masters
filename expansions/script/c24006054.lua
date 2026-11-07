--Frost Specter, Shadow of Age
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GHOST))
	--get ability (slayer)
	dm.AddStaticEffectSlayer(c,DM_LOCATION_BZONE,0,aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_GHOST))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_GHOST}
