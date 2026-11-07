--Pangaea's Song
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana zone
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoMZoneOperation(PLAYER_SELF,Card.IsFaceup,DM_LOCATION_BZONE,0,1))
end
scard.duel_masters_card=true
