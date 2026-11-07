--Ulex, the Dauntless
--Not fully implemented: SetValue doesn't work to only prevent the opponent from tapping it.
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be tapped
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_CANNOT_BE_TAPPED)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(DM_LOCATION_BZONE)
	--Note: Remove aux.NOT(dm.SelfAttackerCondition) if SetValue works
	e1:SetCondition(aux.AND(dm.SelfUntappedCondition,aux.NOT(dm.SelfAttackerCondition)))
	--e1:SetValue(scard.abfilter)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.abfilter(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end
