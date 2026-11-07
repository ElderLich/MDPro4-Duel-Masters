--Lu Gila, Silver Rift Guardian
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--get ability (enter tapped)
	dm.EnableEffectCustom(c,DM_EFFECT_ENTER_BZONE_TAPPED,nil,LOCATION_ALL,LOCATION_ALL,aux.TargetBoolFunction(Card.IsEvolution))
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
