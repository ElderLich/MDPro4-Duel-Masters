--Miraculous Truce
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.regop)
end
scard.duel_masters_card=true
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_CIVILIZATION)
	local civ=Duel.AnnounceCivilization(tp,1,DM_CIVILIZATION_ALL)
	local reset_count=(Duel.GetTurnPlayer()==tp and 2 or 1)
	--cannot attack player
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_CANNOT_ATTACK_PLAYER)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetCondition(dm.CannotAttackPlayerCondition)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(0,DM_LOCATION_BZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsCivilization,civ))
	e2:SetLabelObject(e1)
	e2:SetReset(RESET_PHASE+PHASE_DRAW,reset_count)
	Duel.RegisterEffect(e2,tp)
end
