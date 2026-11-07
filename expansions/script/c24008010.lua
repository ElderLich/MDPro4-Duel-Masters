--Misha, Channeler of Suns
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be attacked
	dm.EnableCannotBeAttacked(c,aux.TargetBoolFunction(Card.DMIsRace,DM_RACE_DRAGON))
end
scard.duel_masters_card=true
