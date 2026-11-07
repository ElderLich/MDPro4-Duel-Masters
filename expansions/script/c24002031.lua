--Lost Soul
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--discard
	dm.AddSpellCastEffect(c,0,nil,dm.DiscardOperation(nil,aux.TRUE,0,LOCATION_HAND))
end
scard.duel_masters_card=true
