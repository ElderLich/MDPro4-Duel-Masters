--King Benthos
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--tap ability (get ability)
	dm.EnableTapAbility(c,0,scard.abtg,scard.abop)
end
scard.duel_masters_card=true
function scard.abfilter(c)
	return c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_WATER)
end
scard.abtg=dm.CheckCardFunction(scard.abfilter,DM_LOCATION_BZONE,0)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.abfilter,tp,DM_LOCATION_BZONE,0,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--cannot be blocked
		dm.RegisterEffectCannotBeBlocked(e:GetHandler(),tc,1)
	end
end
