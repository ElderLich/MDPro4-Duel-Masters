--Cutthroat Skyterror
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
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
