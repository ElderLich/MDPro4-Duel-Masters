--石臼男
--Millstone Man
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (search) (to grave)
	dm.EnableTapAbility(c,0,nil,dm.SendtoGraveOperation(PLAYER_SELF,nil,0,LOCATION_DECK,1))
end
scard.duel_masters_card=true
