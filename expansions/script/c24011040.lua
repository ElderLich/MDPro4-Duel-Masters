--Sapian Tark, Flame Dervish
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (power up)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,0,dm.WaveStrikerCondition)
	dm.EnableUpdatePower(c,4000,dm.WaveStrikerCondition)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
	--wave striker (attack untapped)
	dm.EnableAttackUntapped(c,nil,dm.WaveStrikerCondition)
	dm.AddEffectDescription(c,2,dm.WaveStrikerCondition)
end
scard.duel_masters_card=true
