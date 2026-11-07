--蒼神龍ウォルフィース
--Wolfis, Blue Divine Dragon
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c)
	--get ability
	dm.AddTriggerEffect(c,0,EVENT_CUSTOM+DM_EVENT_BREAK_SHIELD,true,nil,scard.abop,nil,scard.abcon)
	--destroy replace (return)
	dm.AddSingleReplaceEffectDestroy(c,1,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
--get ability
function scard.cfilter(c,tp)
	return c:GetPreviousControler()==tp and not c:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER)
end
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(scard.cfilter,nil,tp)
	g:KeepAlive()
	e:SetLabelObject(g)
	return g:GetCount()>0
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetLabelObject()
	for tc in aux.Next(g) do
		if tc:IsLocation(LOCATION_HAND) and tc:IsBrokenShield() and not tc:IsHasEffect(DM_EFFECT_SHIELD_TRIGGER) then
			--shield trigger
			dm.RegisterEffectCustom(e:GetHandler(),tc,3,DM_EFFECT_SHIELD_TRIGGER)
			Duel.RaiseSingleEvent(tc,EVENT_CUSTOM+DM_EVENT_BECOME_SHIELD_TRIGGER,e,0,0,0,0)
			if tc:IsCreature() and tc:IsAbleToBZone(e,0,tp,false,false) then
				Duel.SendtoBZone(tc,0,tp,tp,false,false,POS_FACEUP_UNTAPPED)
			end
		end
	end
end
--destroy replace (return)
scard.reptg=dm.SingleReplaceDestroyTarget2(2,Card.IsAbleToHand)
scard.repop=dm.SingleReplaceDestroyOperation(Duel.SendtoHand,PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
