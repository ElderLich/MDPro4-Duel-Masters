--Quakesaur
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleTriggerEffect(c,0,EVENT_BATTLE_CONFIRM,nil,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET,scard.tgcon)
end
scard.duel_masters_card=true
scard.tgcon=aux.AND(dm.UnblockedCondition,dm.AttackPlayerCondition)
scard.tgtg=dm.TargetCardFunction(PLAYER_OPPO,dm.ManaZoneFilter(Card.DMIsAbleToGrave),0,DM_LOCATION_MZONE,1,1,DM_HINTMSG_TOGRAVE)
scard.tgop=dm.TargetCardsOperation(Duel.DMSendtoGrave,REASON_EFFECT)
