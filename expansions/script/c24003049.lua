--Masked Pomegranate
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,dm.CannotBeBlockedBoolFunction(Card.IsPowerBelow,4000))
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_NATURE)
end
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(scard.cfilter,c:GetControler(),DM_LOCATION_BZONE,0,c)*1000
end
