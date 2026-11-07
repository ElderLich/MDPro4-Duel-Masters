--Forced Frenzy
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,0,DM_LOCATION_BZONE,nil)
	if g:GetCount()==0 then return end
	local reset_count=(Duel.GetTurnPlayer()==tp and 2 or 1)
	for tc in aux.Next(g) do
		--must attack
		dm.RegisterEffectCustom(e:GetHandler(),tc,1,EFFECT_MUST_ATTACK,RESET_PHASE+PHASE_DRAW,reset_count)
	end
end
