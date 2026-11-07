--Tanzanyte, the Awakener
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--tap ability (return)
	dm.EnableTapAbility(c,0,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.retfilter1(c)
	return c:IsCreature() and c:IsAbleToHand()
end
function scard.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local f=dm.DMGraveFilter(scard.retfilter1)
	if chkc then return chkc:IsLocation(DM_LOCATION_GRAVE) and chkc:IsControler(tp) and f(chkc) end
	if chk==0 then return Duel.IsExistingTarget(f,tp,DM_LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TARGET)
	local tc=Duel.SelectTarget(tp,dm.DMGraveFilter(Card.IsCreature),tp,DM_LOCATION_GRAVE,0,1,1,nil):GetFirst()
	e:SetLabel(tc:GetCode())
end
function scard.retfilter2(c,code)
	return scard.retfilter1(c) and c:IsCode(code)
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(dm.DMGraveFilter(scard.retfilter2),tp,DM_LOCATION_GRAVE,0,nil,e:GetLabel())
	if g:GetCount()==0 then return end
	Duel.SendtoHand(g,PLAYER_OWNER,REASON_EFFECT)
	Duel.ConfirmCards(1-tp,g)
end
