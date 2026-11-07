--Mihail, Celestial Elemental
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be destroyed
	dm.EnableCannotBeDestroyed(c,DM_LOCATION_BZONE,DM_LOCATION_BZONE,dm.TargetBoolFunctionExceptSelf())
end
scard.duel_masters_card=true
