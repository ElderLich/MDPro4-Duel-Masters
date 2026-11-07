--Kilstine, Nebula Elemental
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (power up)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,0,dm.WaveStrikerCondition)
	dm.EnableUpdatePower(c,5000,dm.WaveStrikerCondition,DM_LOCATION_BZONE,0)
	--wave striker (blocker)
	dm.AddStaticEffectBlocker(c,DM_LOCATION_BZONE,0,nil,dm.WaveStrikerCondition)
	--wave striker (double breaker)
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,dm.WaveStrikerCondition,DM_LOCATION_BZONE,0)
end
scard.duel_masters_card=true
