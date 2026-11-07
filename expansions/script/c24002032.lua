--Marrow Ooze, the Twister
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--destroy
	dm.AddSingleTriggerEffect(c,0,EVENT_CUSTOM+DM_EVENT_ATTACK_PLAYER,nil,nil,dm.SelfDestroyOperation())
end
scard.duel_masters_card=true
