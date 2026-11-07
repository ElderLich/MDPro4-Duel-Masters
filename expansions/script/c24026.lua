--聖神龍アルティメス
--Altimeth, Holy Divine Dragon
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--get ability
	dm.AddTriggerEffect(c,0,DM_EVENT_UNTAP_STEP,true,nil,scard.abop)
	--to shield zone
	dm.AddSingleTriggerEffectLeaveBZone(c,1,nil,nil,dm.DecktopSendtoSZoneOperation(PLAYER_SELF,1))
	--tap
	dm.AddSingleTriggerEffect(c,2,DM_EVENT_COME_INTO_PLAY,true,scard.postg,scard.posop)
end
scard.duel_masters_card=true
--get ability
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,nil)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--blocker
		dm.RegisterEffectBlocker(e:GetHandler(),tc,3,RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
	end
end
--tap
function scard.posfilter(c)
	return c:IsFaceup() and c:IsAbleToTap()
end
scard.postg=dm.CheckCardFunction(scard.posfilter,0,DM_LOCATION_BZONE)
scard.posop=dm.TapOperation(nil,scard.posfilter,0,DM_LOCATION_BZONE)
