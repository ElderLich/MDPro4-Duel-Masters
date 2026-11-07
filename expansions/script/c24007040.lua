--Gazarias Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,4000,dm.NoShieldsCondition(PLAYER_SELF))
	dm.AddEffectDescription(c,0,dm.NoShieldsCondition(PLAYER_SELF))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,dm.NoShieldsCondition(PLAYER_SELF))
	dm.AddEffectDescription(c,1,dm.NoShieldsCondition(PLAYER_SELF))
end
scard.duel_masters_card=true
