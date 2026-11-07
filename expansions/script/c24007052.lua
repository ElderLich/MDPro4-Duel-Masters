--Popple, Flowerpetal Dancer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (to mana zone)
	dm.EnableTapAbility(c,0,scard.tmtg,scard.tmop)
end
scard.duel_masters_card=true
scard.tmtg=dm.DecktopSendtoMZoneTarget(PLAYER_SELF)
scard.tmop=dm.DecktopSendtoMZoneOperation(PLAYER_SELF,1)
