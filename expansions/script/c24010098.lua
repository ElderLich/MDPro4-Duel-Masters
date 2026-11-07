--Tajimal, Vizier of Aqua
local dm=require "expansions.utility_dmtcg"
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
