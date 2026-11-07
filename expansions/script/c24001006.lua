--Holy Awe
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--tap
	dm.AddSpellCastEffect(c,0,nil,dm.TapOperation(nil,Card.IsFaceup,0,DM_LOCATION_BZONE))
end
scard.duel_masters_card=true
