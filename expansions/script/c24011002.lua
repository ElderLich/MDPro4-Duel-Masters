--Heavyweight Dragon
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--tap ability (destroy)
	dm.EnableTapAbility(c,0,scard.destg,scard.desop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsTapped()
end
scard.destg=dm.TargetCardFunction(PLAYER_SELF,scard.desfilter,0,DM_LOCATION_BZONE,1,2,DM_HINTMSG_TARGET)
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if g:GetCount()==0 then return end
	local pwr=g:GetSum(Card.GetPower)
	if pwr<e:GetHandler():GetPower() then
		Duel.Destroy(g,REASON_EFFECT)
	end
end
