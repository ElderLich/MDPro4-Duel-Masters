--機動賢者キーン
--Keen, the Mobile Sage
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--power attacker
	dm.EnablePowerAttacker(c,2500)
end
scard.duel_masters_card=true
