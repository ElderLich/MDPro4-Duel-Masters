--Chekicul, Vizier of Endurance
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--no battle
	dm.EnableEffectCustom(c,DM_EFFECT_NO_BLOCK_BATTLE)
	--cannot attack
	dm.EnableCannotAttack(c)
end
scard.duel_masters_card=true
