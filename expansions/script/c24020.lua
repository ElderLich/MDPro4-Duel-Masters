--冥妃アイオリア
--Aioria, Dark Princess
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (destroy)
	dm.EnableTapAbility(c,0,nil,dm.DestroyOperation(PLAYER_SELF,Card.IsFaceup,0,DM_LOCATION_BZONE,1,1,true))
end
scard.duel_masters_card=true
