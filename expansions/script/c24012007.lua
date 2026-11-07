--Cosmic Darts
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--confirm, cast for no cost
	dm.AddSpellCastEffect(c,0,scard.conftg,scard.confop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.conftg=dm.TargetCardFunction(PLAYER_OPPO,dm.ShieldZoneFilter(),DM_LOCATION_SZONE,0,1,1,DM_HINTMSG_TARGET)
function scard.confop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	if tc:IsFacedown() then Duel.ConfirmCards(tp,tc) end
	if tc:IsSpell() then
		Duel.CastFree(tc,tp,REASON_EFFECT)
	end
end
