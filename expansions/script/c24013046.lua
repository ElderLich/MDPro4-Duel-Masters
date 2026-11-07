--剣撃士ザック・ランバー
--Zack Ranba, the Sword Attacker
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,2000,dm.MZoneExclusiveCondition(Card.IsTapped))
	dm.AddEffectDescription(c,0,dm.MZoneExclusiveCondition(Card.IsTapped))
end
scard.duel_masters_card=true
