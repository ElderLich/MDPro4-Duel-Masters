--Marrow Ooze, the Twister
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--destroy
	dm.AddSingleTriggerEffect(c,0,EVENT_CUSTOM+DM_EVENT_ATTACK_PLAYER,nil,nil,dm.SelfDestroyOperation())
end
scard.duel_masters_card=true
