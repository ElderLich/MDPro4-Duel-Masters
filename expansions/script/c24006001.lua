--Invincible Aura
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to shield zone
	dm.AddSpellCastEffect(c,0,nil,dm.DecktopSendtoSZoneUpToOperation(PLAYER_SELF,3))
end
scard.duel_masters_card=true
