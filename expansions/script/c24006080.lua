--Cutthroat Skyterror
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--return
	dm.EnableTurnEndSelfReturn(c)
end
scard.duel_masters_card=true
