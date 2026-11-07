--Dance of the Sproutlings
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana zone
	dm.AddSpellCastEffect(c,0,nil,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmfilter(c,race)
	return c:DMIsRace(race) and c:IsAbleToMZone()
end
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RACE)
	local race=Duel.DMAnnounceRace(tp)
	local ct=Duel.GetMatchingGroupCount(scard.tmfilter,tp,LOCATION_HAND,0,e:GetHandler(),race)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOMZONE)
	local g=Duel.SelectMatchingCard(tp,scard.tmfilter,tp,LOCATION_HAND,0,0,ct,e:GetHandler(),race)
	if g:GetCount()==0 then return end
	Duel.SendtoMZone(g,POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
