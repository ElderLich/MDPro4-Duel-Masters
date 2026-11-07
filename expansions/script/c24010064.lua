--Burnwisp Lizard
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (speed attacker)
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER,nil,DM_LOCATION_BZONE,0,aux.TargetBoolFunction(Card.IsHasEffect,DM_EFFECT_SILENT_SKILL))
end
scard.duel_masters_card=true
