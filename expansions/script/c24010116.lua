--Ultimate Dragon
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
	--crew breaker
	dm.EnableBreaker(c,DM_EFFECT_CREW_BREAKER)
end
scard.duel_masters_card=true
--power up
function scard.cfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_DRAGON)
end
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(scard.cfilter,c:GetControler(),DM_LOCATION_BZONE,0,c)*5000
end
--crew breaker
function scard.crew_breaker_count(c)
	local f=function(c)
		return c:IsFaceup() and c:DMIsRace(DM_RACE_DRAGON)
	end
	return Duel.GetMatchingGroupCount(f,c:GetControler(),DM_LOCATION_BZONE,0,c)+1
end
