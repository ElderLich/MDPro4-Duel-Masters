--黒神龍ガルバロス
--Necrodragon Galbalos
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--choose one (to grave or discard or destroy)
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.opttg,scard.optop)
	dm.AddSingleTriggerEffect(c,0,EVENT_DESTROYED,true,scard.opttg,scard.optop)
end
scard.duel_masters_card=true
function scard.opttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local b1=Duel.IsExistingMatchingCard(dm.ShieldZoneFilter(Card.DMIsAbleToGrave),tp,0,DM_LOCATION_SZONE,1,nil)
	local b2=Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_HAND,1,nil)
	local b3=Duel.IsExistingMatchingCard(Card.IsFaceup,tp,0,DM_LOCATION_BZONE,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local ops={}
	local t={}
	if b1 then
		table.insert(ops,aux.Stringid(sid,1))
		table.insert(t,1)
	end
	if b2 then
		table.insert(ops,aux.Stringid(sid,2))
		table.insert(t,2)
	end
	if b3 then
		table.insert(ops,aux.Stringid(sid,3))
		table.insert(t,3)
	end
	local opt=t[Duel.SelectOption(tp,table.unpack(ops))+1]
	e:SetLabel(opt)
end
function scard.optop(e,tp,eg,ep,ev,re,r,rp)
	local opt=e:GetLabel()
	if opt==1 then
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,dm.ShieldZoneFilter(Card.DMIsAbleToGrave),tp,0,DM_LOCATION_SZONE,1,1,nil)
		if g:GetCount()==0 then return end
		Duel.HintSelection(g)
		Duel.DMSendtoGrave(g,REASON_EFFECT)
	elseif opt==2 then
		Duel.DiscardHand(1-tp,aux.TRUE,1,1,REASON_EFFECT)
	elseif opt==3 then
		Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,Card.IsFaceup,tp,0,DM_LOCATION_BZONE,1,1,nil)
		if g:GetCount()==0 then return end
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
