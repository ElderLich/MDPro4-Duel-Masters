--Rumble Gate
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abfilter(c)
	return c:IsFaceup() and c:IsCanAttackCreature()
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g1=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,nil)
	if g1:GetCount()>0 then
		for tc1 in aux.Next(g1) do
			--power up
			dm.RegisterEffectUpdatePower(c,tc1,1,1000)
		end
	end
	local g2=Duel.GetMatchingGroup(scard.abfilter,tp,DM_LOCATION_BZONE,0,nil)
	if g2:GetCount()==0 then return end
	for tc2 in aux.Next(g2) do
		--attack untapped
		dm.RegisterEffectCustom(c,tc2,2,DM_EFFECT_ATTACK_UNTAPPED)
	end
end
