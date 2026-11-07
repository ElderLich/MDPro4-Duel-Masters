--Diamondia, the Blizzard Rider
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_SNOW_FAERIE))
	--return
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.retop)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_SNOW_FAERIE}
function scard.retfilter(c)
	return c:DMIsRace(DM_RACE_SNOW_FAERIE) and c:IsAbleToHand()
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(dm.DMGraveFilter(scard.retfilter),tp,DM_LOCATION_GRAVE,0,nil)
	local g2=Duel.GetMatchingGroup(dm.ManaZoneFilter(scard.retfilter),tp,DM_LOCATION_MZONE,0,nil)
	g1:Merge(g2)
	Duel.SendtoHand(g1,PLAYER_OWNER,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g1)
end
