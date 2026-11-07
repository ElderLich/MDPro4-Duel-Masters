--Misha, Channeler of Suns
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be attacked
	dm.EnableCannotBeAttacked(c,aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_DRAGON))
end
scard.duel_masters_card=true
