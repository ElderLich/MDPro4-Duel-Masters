--新緑の鉄槌
--Verdant Hammer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wins all battles (ghost)
	dm.EnableWinsAllBattles(c,0,aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_GHOST))
	--power attacker
	dm.EnablePowerAttacker(c,2000)
end
scard.duel_masters_card=true
