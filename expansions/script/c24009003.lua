--Azaghast, Tyrant of Shadows
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_DARK_LORD))
	--destroy
	dm.AddTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.destg,scard.desop,EFFECT_FLAG_CARD_TARGET,scard.descon)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_DARK_LORD}
function scard.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:DMIsRace(DM_RACE_GHOST)
end
function scard.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,e:GetHandler(),tp)
end
function scard.desfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
scard.destg=dm.TargetCardFunction(PLAYER_SELF,scard.desfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_DESTROY)
scard.desop=dm.TargetCardsOperation(Duel.Destroy,REASON_EFFECT)
--[[
	Notes
		1. Script is based on the Japanese rules text
]]
