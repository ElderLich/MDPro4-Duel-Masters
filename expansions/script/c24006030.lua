--Yuluk, the Oracle
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--summon limit
	dm.EnableEffectCustom(c,DM_EFFECT_CANNOT_SUMMON,scard.sumcon)
	Duel.AddCustomActivityCounter(sid,ACTIVITY_CHAIN,scard.chainfilter)
end
scard.duel_masters_card=true
function scard.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_SPELL)
end
function scard.sumcon(e)
	return Duel.GetCustomActivityCount(sid,e:GetHandlerPlayer(),ACTIVITY_CHAIN)==0
end
