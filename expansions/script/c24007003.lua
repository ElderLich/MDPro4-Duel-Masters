--Battleship Mutant
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (get ability)
	dm.EnableTapAbility(c,0,scard.abtg,scard.abop)
end
scard.duel_masters_card=true
function scard.abfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_DARKNESS)
end
scard.abtg=dm.CheckCardFunction(scard.abfilter,DM_LOCATION_BZONE,0)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.abfilter,tp,DM_LOCATION_BZONE,0,nil)
	if g:GetCount()==0 then return end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		--power up
		dm.RegisterEffectUpdatePower(c,tc,2,4000)
		--double breaker
		dm.RegisterEffectBreaker(c,tc,3,DM_EFFECT_DOUBLE_BREAKER)
		--destroy
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(sid,1))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(DM_EVENT_BATTLE_END)
		e1:SetCondition(dm.SelfBattleEndCondition)
		e1:SetOperation(dm.SelfBattleEndOperation)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
