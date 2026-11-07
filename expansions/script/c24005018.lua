--Lurking Eel
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker (fire and nature)
	dm.EnableBlocker(c,nil,DM_DESC_FN_BLOCKER,aux.FilterBoolFunction(Card.IsCivilization,DM_CIVILIZATIONS_FN))
end
scard.duel_masters_card=true
