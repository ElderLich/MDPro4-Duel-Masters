--Terradragon Anrist Vhal
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
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
function scard.cfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_NATURE)
end
function scard.powval(e,c)
	return Duel.GetMatchingGroupCount(scard.cfilter,c:GetControler(),DM_LOCATION_BZONE,0,c)*2000
end
--double breaker
function scard.dbcon(e)
	return e:GetHandler():IsPowerAbove(6000)
end
