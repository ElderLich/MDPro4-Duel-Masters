--Buoyant Blowfish
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
end
scard.duel_masters_card=true
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(dm.ManaZoneFilter(Card.IsTapped),c:GetControler(),0,DM_LOCATION_MZONE,nil)*1000
end
