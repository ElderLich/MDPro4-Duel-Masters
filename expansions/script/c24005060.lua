--Avalanche Giant
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--cannot attack creature
	dm.EnableCannotAttackCreature(c)
	--break
	dm.AddSingleTriggerEffect(c,0,EVENT_CUSTOM+DM_EVENT_BECOME_BLOCKED,nil,nil,dm.BreakOperation(PLAYER_SELF,PLAYER_OPPO,1))
end
scard.duel_masters_card=true
