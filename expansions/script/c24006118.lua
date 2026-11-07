--Lava Walker Executo
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_DRAGO_NOID))
	--get ability (tap ability) (get ability)
	dm.AddStaticEffectTapAbility(c,0,scard.abtg1,scard.abop,DM_LOCATION_BZONE,0,scard.abtg2)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_DRAGO_NOID}
function scard.abfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_FIRE)
end
function scard.abtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(scard.abfilter,tp,DM_LOCATION_BZONE,0,1,nil) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_CREATURE)
	local g=Duel.SelectMatchingCard(tp,scard.abfilter,tp,DM_LOCATION_BZONE,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	--power up
	dm.RegisterEffectUpdatePower(e:GetHandler(),g:GetFirst(),1,3000)
end
scard.abtg2=aux.TargetBoolFunction(Card.IsCivilization,DM_CIVILIZATION_FIRE)
