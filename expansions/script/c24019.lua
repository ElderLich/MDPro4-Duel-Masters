--刹那の影ハカナゲ
--Hanakage, Shadow of Transience
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.EnableBattleWinSelfDestroy(c,0,true)
end
scard.duel_masters_card=true
