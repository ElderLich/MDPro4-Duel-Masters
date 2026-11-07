--Invincible Technology
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--search (to hand)
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoHandOperation(PLAYER_SELF,nil,LOCATION_DECK,0,0,MAX_NUMBER,true))
end
scard.duel_masters_card=true
