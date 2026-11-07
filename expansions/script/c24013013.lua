--メッツアーのアイロン
--Mettza's Iron
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy, to grave
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CUSTOM+DM_EVENT_BREAK_SHIELD)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e1:SetRange(DM_LOCATION_BZONE)
	e1:SetCondition(scard.regcon)
	e1:SetOperation(scard.regop)
	c:RegisterEffect(e1)
	dm.AddTriggerEffect(c,0,EVENT_PHASE+PHASE_END,nil,nil,scard.desop,EFFECT_FLAG_CARD_TARGET,scard.descon)
end
scard.duel_masters_card=true
function scard.regcon(e,tp,eg,ep,ev,re,r,rp)
	return re:GetHandler()==e:GetHandler()
end
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(sid,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
end
function scard.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(sid)>0
end
function scard.tgfilter(c,e)
	return c:DMIsAbleToGrave() and c:IsCanBeEffectTarget(e)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
	Duel.BreakEffect()
	scard.tograve(e,tp)
	scard.tograve(e,1-tp)
end
function scard.tograve(e,tp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(scard.tgfilter),tp,DM_LOCATION_MZONE,0,1,1,nil,e)
	if g:GetCount()==0 then return end
	Duel.SetTargetCard(g)
	Duel.DMSendtoGrave(g,REASON_EFFECT)
end
