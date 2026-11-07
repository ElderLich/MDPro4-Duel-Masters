--Wise Starnoid, Avatar of Hope
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--vortex evolution
	dm.EnableEffectCustom(c,DM_EFFECT_VORTEX_EVOLUTION)
	dm.AddEvolutionProcedure(c,scard.evofilter1,scard.evofilter2)
	--to shield zone
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,nil,dm.DecktopSendtoSZoneOperation(PLAYER_SELF,1))
	dm.AddSingleTriggerEffectLeaveBZone(c,0,nil,nil,dm.DecktopSendtoSZoneOperation(PLAYER_SELF,1))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_LIGHT_BRINGER,DM_RACE_CYBER_LORD,DM_RACE_CYBER}
scard.evofilter1=aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_LIGHT_BRINGER)
scard.evofilter2=aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CYBER_LORD)
