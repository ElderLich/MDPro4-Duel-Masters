--Aqua Strummer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--sort
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.SortDecktopOperation(PLAYER_SELF,PLAYER_SELF,5))
end
scard.duel_masters_card=true
