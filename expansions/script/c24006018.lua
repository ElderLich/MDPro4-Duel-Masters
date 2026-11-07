--Dava Torey, Seeker of Clouds
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard replace (to battle zone)
	dm.AddSingleReplaceEffectDiscard(c,0,scard.reptg,scard.repop,dm.TurnPlayerCondition(PLAYER_OPPO))
end
scard.duel_masters_card=true
function scard.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_DISCARD) and not c:IsReason(REASON_REPLACE)
		and c:IsAbleToBZone(e,0,tp,false,false) end
	return true
end
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SendtoBZone(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
end
