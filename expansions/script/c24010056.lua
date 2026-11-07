--Spark Chemist, Shadow of Whim
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.SendtoHandOperation(nil,dm.ManaZoneFilter(),DM_LOCATION_MZONE,0))
end
scard.duel_masters_card=true
