--Diamond Cutter
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abfilter(c)
	return c:IsFaceup() and (not c:IsCanAttackTurn() or not c:IsCanAttack() or not c:IsCanAttackPlayer())
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.abfilter,tp,DM_LOCATION_BZONE,0,nil)
	if g:GetCount()==0 then return end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		--ignore summoning sickness
		dm.RegisterEffectCustom(c,tc,1,DM_EFFECT_IGNORE_SUMMONING_SICKNESS)
		--ignore cannot attack
		dm.RegisterEffectCustom(c,tc,2,DM_EFFECT_IGNORE_CANNOT_ATTACK)
		--ignore cannot attack player
		dm.RegisterEffectCustom(c,tc,2,DM_EFFECT_IGNORE_CANNOT_ATTACK_PLAYER)
	end
end
