--刹那の影ハカナゲ
--Hanakage, Shadow of Transience
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.EnableBattleWinSelfDestroy(c,0,true)
end
scard.duel_masters_card=true
