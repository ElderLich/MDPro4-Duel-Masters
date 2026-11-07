--Spikestrike Ichthys Q
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (cannot be blocked)
	dm.EnableCannotBeBlocked(c)
	dm.AddStaticEffectCannotBeBlocked(c,LOCATION_ALL,0,dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_SURVIVOR))
end
scard.duel_masters_card=true
