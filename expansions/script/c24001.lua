--界の守護者パール・キャラス
--Pearl Carras, Barrier Guardian
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--wins all battles (human)
	dm.EnableWinsAllBattles(c,0,aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_HUMAN))
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
end
scard.duel_masters_card=true
