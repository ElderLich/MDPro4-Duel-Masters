--Squawking Lunatron
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--silent skill (return)
	dm.EnableSilentSkill(c,0,scard.rettg,scard.retop)
end
scard.duel_masters_card=true
scard.rettg=dm.CheckCardFunction(dm.ManaZoneFilter(Card.IsAbleToHand),DM_LOCATION_MZONE,0)
scard.retop=dm.SendtoHandOperation(PLAYER_SELF,dm.ManaZoneFilter(),DM_LOCATION_MZONE,0,1,3)
