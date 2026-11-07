--Badlands Lizard
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,3000)
	--no battle
	dm.EnableEffectCustom(c,DM_EFFECT_NO_BE_BLOCKED_BATTLE)
end
scard.duel_masters_card=true
