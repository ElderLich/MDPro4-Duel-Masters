--King Nautilus
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability (cannot be blocked)
	dm.AddStaticEffectCannotBeBlocked(c,DM_LOCATION_BZONE,DM_LOCATION_BZONE,aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_LIQUID_PEOPLE))
end
scard.duel_masters_card=true
