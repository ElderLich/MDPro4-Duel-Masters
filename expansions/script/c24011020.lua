--Revival Soldier
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (power up)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
	dm.EnableUpdatePower(c,4000,dm.WaveStrikerCondition)
	dm.AddEffectDescription(c,2,dm.WaveStrikerCondition)
	--wave striker (destroy replace) (return)
	dm.AddSingleReplaceEffectDestroy(c,0,scard.reptg,scard.repop,dm.WaveStrikerCondition)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleReplaceDestroyTarget(Card.IsAbleToHand)
scard.repop=dm.SingleReplaceDestroyOperation(Duel.SendtoHand,PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
