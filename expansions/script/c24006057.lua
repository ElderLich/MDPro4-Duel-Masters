--Gnarvash, Merchant of Blood
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--destroy
	dm.EnableTurnEndSelfDestroy(c,0,scard.descon)
end
scard.duel_masters_card=true
function scard.descon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),DM_LOCATION_BZONE,0)==1
end
