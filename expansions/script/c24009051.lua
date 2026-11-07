--Storm Wrangler, the Furious
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_BEAST_FOLK))
	--get ability
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.abtg,scard.abop1,EFFECT_FLAG_CARD_TARGET)
	--get ability
	dm.AddSingleTriggerEffect(c,1,EVENT_CUSTOM+DM_EVENT_BECOME_BLOCKED,nil,nil,scard.abop2)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_BEAST_FOLK}
function scard.abfilter(c)
	return c:IsFaceup() and c:IsUntapped() and c:IsHasEffect(DM_EFFECT_BLOCKER)
end
scard.abtg=dm.TargetCardFunction(PLAYER_SELF,scard.abfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TARGET)
function scard.abop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not scard.abfilter(tc) then return end
	--must block
	dm.RegisterEffectCustom(e:GetHandler(),tc,2,DM_EFFECT_MUST_BLOCK)
	--raise event to trigger "Blocker"
	Duel.RaiseEvent(tc,EVENT_CUSTOM+DM_EVENT_TRIGGER_BLOCKER,e,0,0,0,0)
end
function scard.abop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	--power up
	dm.RegisterEffectUpdatePower(c,c,3,3000)
end
