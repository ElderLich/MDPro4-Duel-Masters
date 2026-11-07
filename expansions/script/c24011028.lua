--Jagila, the Hidden Pillager
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (discard)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.dhop,nil,dm.WaveStrikerCondition)
end
scard.duel_masters_card=true
scard.dhop=dm.DiscardOperation(PLAYER_OPPO,aux.TRUE,0,LOCATION_HAND,3,3,true)
