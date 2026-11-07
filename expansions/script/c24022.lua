--火焔漁師ガンゾ
--Ganzo, Flame Fisherman
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wins all battles (liquid people)
	dm.EnableWinsAllBattles(c,0,aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_LIQUID_PEOPLE))
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--return
	dm.EnableTurnEndSelfReturn(c,1)
end
scard.duel_masters_card=true
