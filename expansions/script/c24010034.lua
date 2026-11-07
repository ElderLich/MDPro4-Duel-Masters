--Fluorogill Manta
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (cannot be blocked)
	dm.AddStaticEffectCannotBeBlocked(c,DM_LOCATION_BZONE,0,aux.TargetBoolFunction(Card.IsCivilization,DM_CIVILIZATIONS_LD))
end
scard.duel_masters_card=true
