--Lukia Lex, Pinnacle Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,3000)
	--untap
	dm.EnableTurnEndSelfUntap(c)
end
scard.duel_masters_card=true
