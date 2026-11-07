--Chaos Strike
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,scard.abtg,scard.abop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.abfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
scard.abtg=dm.TargetCardFunction(PLAYER_SELF,scard.abfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TARGET)
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not scard.abfilter(tc) then return end
	--make attackable
	dm.RegisterEffectCustom(e:GetHandler(),tc,1,DM_EFFECT_UNTAPPED_BE_ATTACKED)
end
