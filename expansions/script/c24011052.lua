--Live and Breathe
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--get ability
	dm.AddSpellCastEffect(c,0,nil,scard.regop)
end
scard.duel_masters_card=true
function scard.regop(e,tp,eg,ep,ev,re,r,rp)
	--search (to battle zone)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(DM_EVENT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(dm.PlayerSummonCreatureCondition(PLAYER_SELF))
	e1:SetOperation(scard.tbop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function scard.tbfilter(c,e,tp,code)
	return c:IsCreature() and c:IsCode(code) and c:IsAbleToBZone(e,0,tp,false,false)
end
function scard.tbop(e,tp,eg,ep,ev,re,r,rp)
	local code=eg:GetFirst():GetCode()
	local g=Duel.GetMatchingGroup(scard.tbfilter,tp,LOCATION_DECK,0,nil,e,tp,code)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_CARD,0,sid)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOBZONE)
	local sg=g:Select(tp,0,1,nil)
	if sg:GetCount()==0 then return end
	Duel.SendtoBZone(sg,0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
end
--[[
	Notes
		1. The effect of putting a creature into the battle zone does not trigger
		https://duelmasters.fandom.com/wiki/Live_and_Breathe/Rulings
]]
