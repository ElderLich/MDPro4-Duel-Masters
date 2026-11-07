--Hourglass Mutant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (slayer)
	dm.AddStaticEffectSlayer(c,DM_LOCATION_BZONE,0,aux.TargetBoolFunction(Card.IsCivilization,DM_CIVILIZATIONS_WF))
end
scard.duel_masters_card=true
