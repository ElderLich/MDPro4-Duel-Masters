--Mini Titan Gett
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--must attack
	dm.EnableEffectCustom(c,EFFECT_MUST_ATTACK)
	--power attacker
	dm.EnablePowerAttacker(c,1000)
end
scard.duel_masters_card=true
