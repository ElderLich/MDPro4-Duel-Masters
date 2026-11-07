--剛撃戦攻ドルゲーザ
--Dolgeza, Veteran of Hard Battle
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--sympathy (earth eater, giant)
	dm.EnableSympathy(c,DM_RACE_EARTH_EATER,DM_RACE_GIANT)
	--draw
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.drtg,scard.drop)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.cfilter(c,race)
	return c:IsFaceup() and c:DMIsRace(race)
end
function scard.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)
		and (Duel.IsExistingMatchingCard(scard.cfilter,tp,DM_LOCATION_BZONE,0,1,nil,DM_RACE_EARTH_EATER)
		or Duel.IsExistingMatchingCard(scard.cfilter,tp,DM_LOCATION_BZONE,0,1,nil,DM_RACE_GIANT)) end
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BZONE,0,nil,DM_RACE_EARTH_EATER)
	if ct1>0 then
		Duel.Draw(tp,ct1,REASON_EFFECT)
	end
	local ct2=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BZONE,0,nil,DM_RACE_GIANT)
	if ct2>0 and Duel.IsPlayerCanDraw(tp,1) and Duel.SelectYesNo(tp,DM_QHINTMSG_DRAW) then
		Duel.BreakEffect()
		Duel.Draw(tp,ct2,REASON_EFFECT)
	end
end
