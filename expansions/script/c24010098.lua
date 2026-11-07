--Tajimal, Vizier of Aqua
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--power up
	dm.EnableUpdatePower(c,4000,dm.SelfBattlingCondition(aux.FilterBoolFunction(Card.IsCivilization,DM_CIVILIZATION_FIRE)))
end
scard.duel_masters_card=true
