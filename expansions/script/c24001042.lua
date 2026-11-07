--Tropico
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,nil,scard.actcon)
end
scard.duel_masters_card=true
function scard.actcon(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),DM_LOCATION_BZONE,0,2,e:GetHandler())
end
