--機動聖者ミールマックス
--Mobile Saint Meermax
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--attack untapped
	dm.EnableAttackUntapped(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--untap
	dm.EnableBattleWinSelfUntap(c)
end
scard.duel_masters_card=true
