--Bubble Scarab
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--discard, get ability
	dm.AddTriggerEffect(c,0,EVENT_BE_BATTLE_TARGET,true,scard.dhtg,scard.dhop,nil,scard.dhcon)
end
scard.duel_masters_card=true
function scard.dhcon(e,tp,eg,ep,ev,re,r,rp)
	local d=Duel.GetAttackTarget()
	return d and d:IsFaceup() and d:IsControler(tp)
end
scard.dhtg=dm.CheckCardFunction(aux.TRUE,LOCATION_HAND,0)
function scard.dhop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT)==0 then return end
	--power up
	dm.RegisterEffectUpdatePower(e:GetHandler(),Duel.GetAttackTarget(),1,3000)
end
