--Calgo, Vizier of Rainclouds
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,dm.CannotBeBlockedBoolFunction(Card.IsPowerAbove,4000))
end
scard.duel_masters_card=true
