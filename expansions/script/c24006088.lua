--Rumblesaur Q
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (speed attacker)
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER,nil,LOCATION_ALL,0,dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_SURVIVOR))
end
scard.duel_masters_card=true
