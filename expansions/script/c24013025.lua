--獣達の挽歌
--Funeral Song of the Beasts
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--power up
		dm.RegisterEffectUpdatePower(e:GetHandler(),tc,2,4000)
		--break
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(aux.Stringid(sid,1))
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
		e1:SetCode(EVENT_CUSTOM+DM_EVENT_BECOME_BLOCKED)
		e1:SetCondition(scard.brcon)
		e1:SetTarget(dm.HintTarget)
		e1:SetOperation(dm.BreakOperation(PLAYER_SELF,PLAYER_OPPO,1,1,tc))
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc:RegisterFlagEffect(0,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(sid,3))
	end
end
function scard.brcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetAttackTarget()==nil and e:GetHandler():IsBlocked()
end
