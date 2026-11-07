--Tentacle Cluster
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.AddSingleTriggerEffect(c,0,EVENT_BATTLE_CONFIRM,true,scard.rettg,scard.retop,EFFECT_FLAG_CARD_TARGET,scard.retcon)
end
scard.duel_masters_card=true
scard.retcon=aux.AND(dm.UnblockedCondition,dm.AttackPlayerCondition)
function scard.retfilter(c)
	return c:IsFaceup() and c:IsAbleToHand()
end
scard.rettg=dm.TargetCardFunction(PLAYER_SELF,scard.retfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE,1,1,DM_HINTMSG_RTOHAND)
scard.retop=dm.TargetSendtoHandOperation()
