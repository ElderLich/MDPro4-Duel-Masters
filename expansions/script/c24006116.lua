--Phantasmal Horror Gigazald
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CHIMERA))
	--get ability (tap ability) (discard)
	dm.AddStaticEffectTapAbility(c,0,scard.dhtg1,scard.dhop,DM_LOCATION_BZONE,0,scard.dhtg2)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_CHIMERA}
function scard.dhtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
scard.dhop=dm.DiscardOperation(PLAYER_OPPO,aux.TRUE,0,LOCATION_HAND,1,1,true)
scard.dhtg2=aux.TargetBoolFunction(Card.IsCivilization,DM_CIVILIZATION_DARKNESS)
