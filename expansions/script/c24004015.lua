--Re Bil, Seeker of Archery
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,2000,nil,DM_LOCATION_BZONE,DM_LOCATION_BZONE,dm.TargetBoolFunctionExceptSelf(Card.IsCivilization,DM_CIVILIZATION_LIGHT))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
