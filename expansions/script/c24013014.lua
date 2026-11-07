--地脈の超人
--Ground Giant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.dbcon)
	dm.AddEffectDescription(c,0,scard.dbcon)
end
scard.duel_masters_card=true
--power up
function scard.powval(e,c)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,c:GetControler(),DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil)
	local ct=g:GetClassCount(Card.GetCivilization)
	return ct*2000
end
--double breaker
function scard.dbcon(e)
	return e:GetHandler():GetPower()>6000
end
