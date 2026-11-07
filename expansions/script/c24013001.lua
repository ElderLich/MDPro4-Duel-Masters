--悪魔聖霊バルホルス
--Balforce, the Demonic Holy Spirit
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--get ability (must attack)
	dm.EnableEffectCustom(c,EFFECT_MUST_ATTACK,nil,0,DM_LOCATION_BZONE)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--untap
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_BATTLE_END,nil,nil,dm.SelfUntapOperation(),nil,dm.SelfBlockCondition)
end
scard.duel_masters_card=true
