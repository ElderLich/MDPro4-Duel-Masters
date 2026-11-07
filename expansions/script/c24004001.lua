--Alcadeias, Lord of Spirits
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_ANGEL_COMMAND))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--cannot cast
	dm.EnablePlayerEffectCustom(c,EFFECT_CANNOT_ACTIVATE,1,1,scard.actval)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_ANGEL_COMMAND,DM_RACE_COMMAND}
function scard.actval(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsSpell() and not rc:IsCivilization(DM_CIVILIZATION_LIGHT)
end
