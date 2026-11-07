--Miracle Portal
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,scard.abtg,scard.abop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.abtg=dm.TargetCardFunction(PLAYER_SELF,Card.IsFaceup,DM_LOCATION_BZONE,0,1,1,DM_HINTMSG_TARGET)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not tc:IsFaceup() then return end
	local c=e:GetHandler()
	--cannot be blocked
	dm.RegisterEffectCannotBeBlocked(c,tc,1)
	--ignore summoning sickness
	dm.RegisterEffectCustom(c,tc,2,DM_EFFECT_IGNORE_SUMMONING_SICKNESS)
	--ignore cannot attack
	dm.RegisterEffectCustom(c,tc,3,DM_EFFECT_IGNORE_CANNOT_ATTACK)
	--ignore cannot attack player
	dm.RegisterEffectCustom(c,tc,3,DM_EFFECT_IGNORE_CANNOT_ATTACK_PLAYER)
end
