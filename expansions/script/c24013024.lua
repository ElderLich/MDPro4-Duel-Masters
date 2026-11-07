--照準野郎ジルバ
--Lockon Dude Jiruba
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--silent skill (get ability)
	dm.EnableSilentSkill(c,0,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,e:GetHandler())
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--attack untapped
		dm.RegisterEffectCustom(e:GetHandler(),tc,1,DM_EFFECT_ATTACK_UNTAPPED)
	end
end
