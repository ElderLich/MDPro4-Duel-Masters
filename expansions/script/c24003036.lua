--Blaze Cannon
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop,nil,scard.abcon)
end
scard.duel_masters_card=true
scard.abcon=dm.MZoneExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_FIRE)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--power attacker
		dm.RegisterEffectPowerAttacker(e:GetHandler(),tc,1,4000)
		--double breaker
		dm.RegisterEffectBreaker(e:GetHandler(),tc,2,DM_EFFECT_DOUBLE_BREAKER)
	end
end
