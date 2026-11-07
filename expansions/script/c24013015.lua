--薫風妖精コートニー
--Courtney, Summer Breeze Faerie
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--add civilization
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(DM_EFFECT_ADD_CIVILIZATION)
	e1:SetRange(DM_LOCATION_BZONE)
	e1:SetTargetRange(DM_LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsMana))
	e1:SetValue(DM_CIVILIZATION_ALL)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
