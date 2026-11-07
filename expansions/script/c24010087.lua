--Legacy Shell
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (power attacker)
	dm.AddStaticEffectPowerAttacker(c,3000,DM_LOCATION_BZONE,0,aux.TargetBoolFunction(Card.IsCivilization,DM_CIVILIZATIONS_LF))
end
scard.duel_masters_card=true
