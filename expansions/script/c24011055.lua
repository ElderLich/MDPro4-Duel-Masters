--Reap and Sow
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to grave, to mana zone
	dm.AddSpellCastEffect(c,0,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.tgtg=dm.TargetCardFunction(PLAYER_SELF,dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MZONE,1,1,DM_HINTMSG_TOGRAVE)
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.DMSendtoGrave(tc,REASON_EFFECT)
	end
	Duel.BreakEffect()
	Duel.SendDecktoptoMZone(tp,1,POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
