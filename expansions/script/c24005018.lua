--Lurking Eel
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker (fire and nature)
	dm.EnableBlocker(c,nil,DM_DESC_FN_BLOCKER,aux.FilterBoolFunction(Card.IsCivilization,DM_CIVILIZATIONS_FN))
end
scard.duel_masters_card=true
