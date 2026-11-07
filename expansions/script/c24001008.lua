--Iocant, the Oracle
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--power up
	dm.EnableUpdatePower(c,2000,dm.ExistingCardCondition(scard.cfilter))
	dm.AddEffectDescription(c,0,dm.ExistingCardCondition(scard.cfilter))
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_ANGEL_COMMAND)
end
