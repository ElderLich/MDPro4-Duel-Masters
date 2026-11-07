--Melnia, the Aqua Shadow
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c)
	--slayer
	dm.EnableSlayer(c)
end
scard.duel_masters_card=true
