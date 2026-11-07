--Pala Olesis, Morning Guardian
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--power up
	dm.EnableUpdatePower(c,2000,dm.TurnPlayerCondition(PLAYER_OPPO),DM_LOCATION_BZONE,0,dm.TargetBoolFunctionExceptSelf())
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
