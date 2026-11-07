--La Byle, Seeker of the Winds
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--untap
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_BATTLE_END,nil,nil,dm.SelfUntapOperation(),nil,dm.SelfBlockCondition)
end
scard.duel_masters_card=true
