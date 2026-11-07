--Marching Motherboard
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.drtg,scard.drop,nil,scard.drcon)
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsFaceup() and c:GetSummonPlayer()==tp and c:DMIsRace(DM_RACE_CYBER)
end
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,e:GetHandler(),tp)
end
scard.drtg=dm.DrawTarget(PLAYER_SELF)
scard.drop=dm.DrawOperation(PLAYER_SELF,1)
