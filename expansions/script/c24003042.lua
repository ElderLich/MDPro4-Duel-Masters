--Snip Striker Bullraizer
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack
	dm.EnableCannotAttack(c,scard.atcon)
end
scard.duel_masters_card=true
function scard.atcon(e)
	local tp=e:GetHandlerPlayer()
	local ct1=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,DM_LOCATION_BZONE,0,nil)
	local ct2=Duel.GetMatchingGroupCount(Card.IsFaceup,tp,0,DM_LOCATION_BZONE,nil)
	return ct2>ct1
end
