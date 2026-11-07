--Cursed Pincher
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--slayer
	dm.EnableSlayer(c)
	--cannot attack
	dm.EnableCannotAttack(c)
end
scard.duel_masters_card=true
