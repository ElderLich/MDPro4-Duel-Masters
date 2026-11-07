--Energy Stream
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--draw
	dm.AddSpellCastEffect(c,0,nil,dm.DrawOperation(PLAYER_SELF,2))
end
scard.duel_masters_card=true
