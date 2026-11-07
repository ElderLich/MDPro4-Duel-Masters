--Earthstomp Giant
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--return
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,nil,dm.SendtoHandOperation(nil,dm.ManaZoneFilter(Card.IsCreature),DM_LOCATION_MZONE,0))
end
scard.duel_masters_card=true
