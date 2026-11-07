--Q-tronic Omnistrain
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_SURVIVOR))
	--add race
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(DM_EFFECT_ADD_RACE)
	e1:SetRange(DM_LOCATION_BZONE)
	e1:SetTargetRange(DM_LOCATION_BZONE,0)
	e1:SetValue(DM_RACE_SURVIVOR)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_SURVIVOR}
