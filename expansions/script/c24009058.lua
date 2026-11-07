--Stallob, the Lifequasher
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--destroy
	dm.AddSingleTriggerEffect(c,0,EVENT_DESTROYED,nil,nil,dm.DestroyOperation(nil,Card.IsFaceup,DM_LOCATION_BZONE,DM_LOCATION_BZONE))
end
scard.duel_masters_card=true
