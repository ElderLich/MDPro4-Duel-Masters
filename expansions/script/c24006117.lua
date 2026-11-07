--Bolmeteus Steel Dragon
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--break replace (to grave)
	dm.AddReplaceEffectBreakShield(c,DM_LOCATION_GRAVE)
end
scard.duel_masters_card=true
