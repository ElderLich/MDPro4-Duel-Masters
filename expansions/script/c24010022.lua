--Pala Olesis, Morning Guardian
local dm=require "expansions.utility_dmtcg"
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
