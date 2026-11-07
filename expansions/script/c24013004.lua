--霊樹海嶺ガウルザガンタ
--Gaulzaganta, Spirit of the Woodland Ridges
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--sympathy (gel fish, snow faerie)
	dm.EnableSympathy(c,DM_RACE_GEL_FISH,DM_RACE_SNOW_FAERIE)
	--tap
	dm.AddTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.posop,nil,scard.poscon)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsEvolution()
end
function scard.poscon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil)
end
function scard.posfilter(c)
	return c:IsFaceup() and c:IsEvolution() and c:IsUntapped()
end
scard.posop=dm.TapOperation(nil,scard.posfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE)
