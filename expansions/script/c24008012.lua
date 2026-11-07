--Sasha, Channeler of Suns
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker (dragon)
	dm.EnableBlocker(c,nil,DM_DESC_DRAGON_BLOCKER,aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_DRAGON))
	--power up
	dm.EnableUpdatePower(c,6000,dm.SelfBattlingCondition(aux.FilterBoolFunction(Card.DMIsRace,DM_RACE_DRAGON)))
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
