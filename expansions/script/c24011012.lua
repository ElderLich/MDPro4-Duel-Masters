--Nial, Vizier of Dexterity
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--untap
	dm.EnableTurnEndSelfUntap(c)
end
scard.duel_masters_card=true
