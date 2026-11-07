--再生の使徒ノルカ・ソルカ
--Nolka Solka, Vizier of Regeneration
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cost down
	dm.EnableUpdatePlayCost(c,-3,LOCATION_ALL,0,aux.TargetBoolFunction(Card.IsSpell))
	--tap ability (return)
	dm.EnableTapAbility(c,0,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.retfilter1(c)
	return c:IsSpell() and c:IsAbleToHand()
end
function scard.retfilter2(c,e)
	return scard.retfilter1(c) and c:IsCanBeEffectTarget(e)
end
function scard.rettg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local f=dm.ManaZoneFilter(scard.retfilter1)
	if chkc then return chkc:IsLocation(DM_LOCATION_MZONE) and chkc:IsControler(tp) and f(chkc) end
	if chk==0 then return Duel.IsExistingTarget(f,tp,DM_LOCATION_MZONE,0,1,nil) end
	local g=Duel.GetMatchingGroup(dm.ManaZoneFilter(scard.retfilter2),tp,DM_LOCATION_MZONE,0,nil,e):RandomSelect(tp,1)
	Duel.SetTargetCard(g)
end
scard.retop=dm.TargetSendtoHandOperation()
