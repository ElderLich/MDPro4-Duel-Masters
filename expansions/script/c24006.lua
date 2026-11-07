--新緑の鉄槌
--Verdant Hammer
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wins all battles (ghost)
	dm.EnableWinsAllBattles(c,0,aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_GHOST))
	--power attacker
	dm.EnablePowerAttacker(c,2000)
end
scard.duel_masters_card=true
