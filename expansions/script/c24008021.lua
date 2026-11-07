--Lalicious
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.conftg,scard.confop)
end
scard.duel_masters_card=true
function scard.conftg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,1,nil)
		or Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
end
function scard.confop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(aux.NOT(Card.IsPublic),tp,0,LOCATION_HAND,nil)
	local g2=Duel.GetDecktopGroup(1-tp,1)
	if g1:GetCount()>0 then
		Duel.ConfirmCards(tp,g1)
	end
	if g2:GetCount()>0 then
		Duel.ConfirmCards(tp,g2)
	end
end
