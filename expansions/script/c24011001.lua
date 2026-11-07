--Evil Incarnate
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_DEVIL_MASK))
	--destroy
	dm.AddTriggerEffect(c,0,DM_EVENT_UNTAP_STEP,nil,nil,scard.desop,EFFECT_FLAG_CARD_TARGET)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_DEVIL_MASK}
--Note: Moved card targeting to the operation function in the event opponent also has Evil Incarnate in the battle zone
--This prevents the turn player from choosing the same monster again to destroy as the chain resolves
--[[
function scard.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local turnp=Duel.GetTurnPlayer()
	if chkc then return chkc:IsLocation(DM_LOCATION_BZONE) and chkc:IsControler(turnp) and chkc:IsFaceup() end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,turnp,DM_HINTMSG_DESTROY)
	Duel.SelectTarget(turnp,Card.IsFaceup,turnp,DM_LOCATION_BZONE,0,1,1,nil)
end
scard.desop=dm.TargetCardsOperation(Duel.Destroy,REASON_EFFECT)
]]
function scard.desfilter(c,e)
	return c:IsFaceup() and c:IsCanBeEffectTarget(e)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	Duel.Hint(HINT_SELECTMSG,turnp,DM_HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(turnp,scard.desfilter,turnp,DM_LOCATION_BZONE,0,1,1,nil,e)
	if g:GetCount()==0 then return end
	Duel.SetTargetCard(g)
	Duel.Destroy(g,REASON_EFFECT)
end
