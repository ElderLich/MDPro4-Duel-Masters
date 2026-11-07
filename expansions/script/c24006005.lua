--Invincible Abyss
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--destroy
	dm.AddSpellCastEffect(c,0,nil,dm.DestroyOperation(nil,Card.IsFaceup,0,DM_LOCATION_BZONE))
end
scard.duel_masters_card=true
