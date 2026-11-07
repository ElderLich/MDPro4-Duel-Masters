--妖蟲幻風ギュネール
--Spectral Worm Giunair
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--slayer
	dm.EnableSlayer(c)
end
scard.duel_masters_card=true
