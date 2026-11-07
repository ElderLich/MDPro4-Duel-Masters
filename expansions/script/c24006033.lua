--Fort Megacluster
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CYBER_CLUSTER))
	--get ability (tap ability) (draw)
	dm.AddStaticEffectTapAbility(c,0,scard.drtg1,scard.drop,DM_LOCATION_BZONE,0,scard.drtg2)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_CYBER_CLUSTER,DM_RACE_CYBER}
function scard.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
scard.drop=dm.DrawOperation(PLAYER_SELF,1)
scard.drtg2=aux.TargetBoolFunction(Card.IsCivilization,DM_CIVILIZATION_WATER)
