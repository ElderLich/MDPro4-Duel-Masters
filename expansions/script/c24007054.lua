--Tangle Fist, the Weaver
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (to mana zone)
	dm.EnableTapAbility(c,0,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
scard.tmtg=dm.CheckCardFunction(Card.IsAbleToMZone,LOCATION_HAND,0)
scard.tmop=dm.SendtoMZoneOperation(PLAYER_SELF,nil,LOCATION_HAND,0,1,3)
