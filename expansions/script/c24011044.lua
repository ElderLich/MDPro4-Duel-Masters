--Macho Melon
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (power attacker)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,0,dm.WaveStrikerCondition)
	dm.EnablePowerAttacker(c,3000,dm.WaveStrikerCondition)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
end
scard.duel_masters_card=true
