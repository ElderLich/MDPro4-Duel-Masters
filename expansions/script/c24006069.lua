--Vile Mulder, Wing of the Void
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack creature
	dm.EnableCannotAttackCreature(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--destroy
	dm.EnableBattleEndSelfDestroy(c)
end
scard.duel_masters_card=true
