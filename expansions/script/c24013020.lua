--吸引のシーリゲル
--Sirigel, the Absorber
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.rettg,scard.retop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.rettg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(dm.ManaZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_MZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(dm.ShieldZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_SZONE,0,1,nil) end
end
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(dm.ManaZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_MZONE,0,nil)
	local g2=Duel.GetMatchingGroup(dm.ShieldZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_SZONE,0,nil)
	if g1:GetCount()==0 and g2:GetCount()==0 then return end
	local ops={}
	local t={}
	if g1:GetCount()>0 then
		table.insert(ops,aux.Stringid(sid,1))
		table.insert(t,1)
	end
	if g2:GetCount()>0 then
		table.insert(ops,aux.Stringid(sid,2))
		table.insert(t,2)
	end
	local opt=t[Duel.SelectOption(tp,table.unpack(ops))+1]
	local g=(opt==1 and g1) or (opt==2 and g2)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RTOHAND)
	local sg=g:Select(tp,1,1,nil)
	Duel.SendtoHand(sg,PLAYER_OWNER,REASON_EFFECT)
	if opt==1 then Duel.ConfirmCards(1-tp,sg) end
end
