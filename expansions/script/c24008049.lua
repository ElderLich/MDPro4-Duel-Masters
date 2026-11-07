--Dracodance Totem
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy replace (to mana zone, return)
	dm.AddSingleReplaceEffectDestroy(c,0,scard.reptg,scard.repop,scard.repcon)
end
scard.duel_masters_card=true
function scard.repcon(e)
	return Duel.IsExistingMatchingCard(dm.ManaZoneFilter(Card.DMIsRace),e:GetHandlerPlayer(),DM_LOCATION_MZONE,0,1,nil,DM_RACE_DRAGON)
end
scard.reptg=dm.SingleReplaceDestroyTarget(Card.IsAbleToMZone)
function scard.thfilter(c)
	return c:DMIsRace(DM_RACE_DRAGON) and c:IsAbleToHand()
end
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SendtoMZone(e:GetHandler(),POS_FACEUP_UNTAPPED,REASON_EFFECT+REASON_REPLACE)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local g=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(scard.thfilter),tp,DM_LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()==0 then return end
	Duel.BreakEffect()
	Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
