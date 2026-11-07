--死皇帝ベルセバ
--Belzeber, Emperor of Death
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_DARK_LORD))
	--to grave
	dm.AddTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET,scard.tgcon)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_DARK_LORD}
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFaceup,1,e:GetHandler())
end
function scard.tgtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local p=eg:GetFirst():GetOwner()
	local f=dm.ManaZoneFilter(Card.DMIsAbleToGrave)
	if chkc then return chkc:IsLocation(DM_LOCATION_MZONE) and chkc:IsControler(p) and f(chkc) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,p,DM_HINTMSG_TOGRAVE)
	Duel.SelectTarget(p,f,p,DM_LOCATION_MZONE,0,1,1,nil)
end
scard.tgop=dm.TargetCardsOperation(Duel.DMSendtoGrave,REASON_EFFECT)
