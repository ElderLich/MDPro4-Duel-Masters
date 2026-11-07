--Spinal Parasite
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddTriggerEffect(c,0,DM_EVENT_UNTAP_STEP,nil,scard.abtg,scard.abop,EFFECT_FLAG_CARD_TARGET,scard.abcon)
end
scard.duel_masters_card=true
scard.abcon=dm.TurnPlayerCondition(PLAYER_OPPO)
function scard.abfilter(c)
	return c:IsFaceup() and c:IsCanAttack()
end
scard.abtg=dm.TargetCardFunction(PLAYER_OPPO,scard.abfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TARGET)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not scard.abfilter(tc) then return end
	--must attack
	dm.RegisterEffectCustom(e:GetHandler(),tc,1,EFFECT_MUST_ATTACK)
end
