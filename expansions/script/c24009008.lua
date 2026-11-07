--Cyclolink, Spectral Knight
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--search (to hand)
	dm.AddSingleTriggerEffect(c,0,EVENT_BATTLE_CONFIRM,nil,nil,scard.thop,nil,scard.thcon)
end
scard.duel_masters_card=true
scard.thcon=aux.AND(dm.UnblockedCondition,dm.AttackPlayerCondition)
scard.thop=dm.SendtoHandOperation(PLAYER_SELF,Card.IsSpell,LOCATION_DECK,0,0,1,true)
