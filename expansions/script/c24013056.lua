--龍炎鳳エターナル・フェニックス
--Eternal Phoenix, Phoenix of the Dragonflame
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--vortex evolution
	dm.EnableEffectCustom(c,DM_EFFECT_VORTEX_EVOLUTION)
	dm.AddEvolutionProcedure(c,scard.evofilter1,scard.evofilter2)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability (attack untapped)
	dm.EnableAttackUntapped(c,nil,nil,DM_LOCATION_BZONE,0,aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_PHOENIX,DM_RACE_DRAGON))
	--return
	dm.AddSingleTriggerEffectLeaveBZone(c,0,nil,nil,dm.SendtoHandOperation(nil,dm.DMGraveFilter(scard.retfilter),DM_LOCATION_GRAVE,0))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_FIRE_BIRD,DM_RACE_ARMORED_DRAGON,DM_RACE_DRAGON}
--vortex evolution
scard.evofilter1=aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_FIRE_BIRD)
scard.evofilter2=aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_ARMORED_DRAGON)
--return
function scard.retfilter(c)
	return c:IsCreature() and not c:IsEvolution() and c:IsCivilization(DM_CIVILIZATION_FIRE)
end
