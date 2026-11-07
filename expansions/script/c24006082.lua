--Migasa, Adept of Chaos
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
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_FIRE)
end
scard.abtg=dm.CheckCardFunction(scard.abfilter,DM_LOCATION_BZONE,0)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_CREATURE)
	local g=Duel.SelectMatchingCard(tp,scard.abfilter,tp,DM_LOCATION_BZONE,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.HintSelection(g)
	--double breaker
	dm.RegisterEffectBreaker(e:GetHandler(),g:GetFirst(),1,DM_EFFECT_DOUBLE_BREAKER)
end
