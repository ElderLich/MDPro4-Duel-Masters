--Armored Cannon Balbaro
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_HUMAN))
	--power up
	dm.EnableUpdatePower(c,scard.powval,dm.SelfAttackerCondition)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_HUMAN}
function scard.cfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_HUMAN)
end
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(scard.cfilter,c:GetControler(),DM_LOCATION_BZONE,DM_LOCATION_BZONE,c)*2000
end
--[[
	References
		1. Perfect Machine King
		https://github.com/Fluorohydride/ygopro-scripts/blob/6324c1c/c18891691.lua#L13
		2. Chthonian Alliance
		https://github.com/Fluorohydride/ygopro-scripts/blob/6324c1c/c46910446.lua#L43
]]
