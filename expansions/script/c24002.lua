--アクア・ハンター
--Aqua Hunter
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wins all battles (beast folk)
	dm.EnableWinsAllBattles(c,0,aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_BEAST_FOLK))
	--cannot be blocked
	dm.EnableCannotBeBlocked(c)
end
scard.duel_masters_card=true
