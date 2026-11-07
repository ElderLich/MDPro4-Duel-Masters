--Gigazoul
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack
	dm.EnableCannotAttack(c,dm.NoShieldsCondition(PLAYER_OPPO))
	dm.AddEffectDescription(c,0,dm.NoShieldsCondition(PLAYER_OPPO))
end
scard.duel_masters_card=true
