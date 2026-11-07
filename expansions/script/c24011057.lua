--Klujadras
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (draw)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.drop,nil,dm.WaveStrikerCondition)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsHasEffect(DM_EFFECT_WAVE_STRIKER)
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local ct1=Duel.GetMatchingGroupCount(scard.cfilter,tp,DM_LOCATION_BZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(scard.cfilter,tp,0,DM_LOCATION_BZONE,nil)
	Duel.Draw(tp,ct1,REASON_EFFECT)
	Duel.Draw(1-tp,ct2,REASON_EFFECT)
end
