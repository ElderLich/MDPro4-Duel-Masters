--Aqua Master
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm
	dm.AddSingleTriggerEffect(c,0,EVENT_BATTLE_CONFIRM,nil,scard.conftg,scard.confop,EFFECT_FLAG_CARD_TARGET,scard.confcon)
end
scard.duel_masters_card=true
scard.confcon=aux.AND(dm.UnblockedCondition,dm.AttackPlayerCondition)
scard.conftg=dm.TargetCardFunction(PLAYER_SELF,dm.ShieldZoneFilter(Card.IsFacedown),0,DM_LOCATION_SZONE,1)
scard.confop=dm.TargetConfirmOperation(true)
