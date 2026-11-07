--猛菌剣兵チックチック
--Tick Tick, Swift Viral Swordfighter
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--draw
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,dm.DrawTarget(PLAYER_SELF),dm.DrawOperation(PLAYER_SELF,1))
end
scard.duel_masters_card=true
