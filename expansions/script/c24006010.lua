--Splinterclaw Wasp
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,3000)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--break
	dm.AddSingleTriggerEffect(c,0,EVENT_CUSTOM+DM_EVENT_BECOME_BLOCKED,nil,nil,dm.BreakOperation(PLAYER_SELF,PLAYER_OPPO,1))
end
scard.duel_masters_card=true
