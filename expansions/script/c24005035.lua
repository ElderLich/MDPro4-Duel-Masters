--Wisp Howler, Shadow of Tears
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--slayer (nature and light)
	dm.EnableSlayer(c,nil,DM_DESC_NL_SLAYER,aux.FilterBoolFunction(Card.IsCivilization,DM_CIVILIZATIONS_LN))
end
scard.duel_masters_card=true
