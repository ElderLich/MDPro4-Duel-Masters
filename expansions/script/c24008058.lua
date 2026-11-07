--Super Necrodragon Abzo Dolba
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_DRAGON))
	--power up
	dm.EnableUpdatePower(c,scard.powval)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_DRAGON}
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(dm.DMGraveFilter(Card.IsCreature),c:GetControler(),DM_LOCATION_GRAVE,0,nil)*2000
end
