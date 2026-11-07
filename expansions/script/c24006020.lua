--Gariel, Elemental of Sunbeams
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--summon limit
	dm.EnableEffectCustom(c,DM_EFFECT_CANNOT_SUMMON,scard.sumcon)
	Duel.AddCustomActivityCounter(sid,ACTIVITY_CHAIN,scard.chainfilter)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.chainfilter(re,tp,cid)
	return not re:IsActiveType(TYPE_SPELL)
end
function scard.sumcon(e)
	return Duel.GetCustomActivityCount(sid,e:GetHandlerPlayer(),ACTIVITY_CHAIN)==0
end
