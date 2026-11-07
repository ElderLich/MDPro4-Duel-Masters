--Vreemah, Freaky Mojo Totem
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.abop,nil,scard.abcon)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp
end
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,e:GetHandler(),tp)
end
function scard.abfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_BEAST_FOLK)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.abfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil)
	if g:GetCount()==0 then return end
	local c=e:GetHandler()
	for tc in aux.Next(g) do
		--power up
		dm.RegisterEffectUpdatePower(c,tc,1,2000*eg:GetCount())
		--double breaker
		dm.RegisterEffectBreaker(c,tc,2,DM_EFFECT_DOUBLE_BREAKER)
	end
end
