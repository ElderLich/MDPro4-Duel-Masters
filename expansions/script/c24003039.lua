--Flametropus
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,scard.tgtg,scard.tgop)
end
scard.duel_masters_card=true
scard.tgtg=dm.CheckCardFunction(dm.ManaZoneFilter(Card.DMIsAbleToGrave),DM_LOCATION_MZONE,0)
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(Card.DMIsAbleToGrave),tp,DM_LOCATION_MZONE,0,1,1,nil)
	if g:GetCount()==0 or Duel.DMSendtoGrave(g,REASON_EFFECT)==0 then return end
	local c=e:GetHandler()
	--power attacker
	dm.RegisterEffectPowerAttacker(c,c,1,3000,0)
	--double breaker
	dm.RegisterEffectBreaker(c,c,2,DM_EFFECT_DOUBLE_BREAKER,0)
end
