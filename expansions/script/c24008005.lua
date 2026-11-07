--Kachua, Keeper of the Icegate
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (search) (to battle zone)
	dm.EnableTapAbility(c,0,scard.tbtg,scard.tbop)
end
scard.duel_masters_card=true
scard.tbtg=dm.CheckDeckFunction(PLAYER_SELF)
function scard.tbfilter(c,e,tp)
	return c:DMIsRace(DM_RACE_DRAGON) and c:IsAbleToBZone(e,0,tp,false,false)
end
function scard.tbop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOBZONE)
	local tc=Duel.SelectMatchingCard(tp,scard.tbfilter,tp,LOCATION_DECK,0,0,1,nil,e,tp):GetFirst()
	if not tc or not Duel.SendtoBZoneStep(tc,0,tp,tp,false,false,POS_FACEUP_UNTAPPED) then return end
	local c=e:GetHandler()
	--speed attacker
	dm.RegisterEffectCustom(c,tc,2,DM_EFFECT_SPEED_ATTACKER)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(sid,1))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(DM_LOCATION_BZONE)
	e1:SetCountLimit(1)
	e1:SetOperation(scard.desop)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
	Duel.SendtoBZoneComplete()
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsDestructable() then return end
	Duel.Hint(HINT_CARD,0,sid)
	Duel.Destroy(c,REASON_EFFECT)
end
--[[
	Notes
		1. An evolution creature may only be put into the battle zone if there is a compatible creature to evolve onto
		https://duelmasters.fandom.com/wiki/Kachua,_Keeper_of_the_Icegate/Rulings
]]
