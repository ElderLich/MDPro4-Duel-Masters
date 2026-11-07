--Venom Capsule
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--silent skill (break)
	dm.EnableSilentSkill(c,0,scard.brtg,dm.BreakOperation(PLAYER_SELF,PLAYER_OPPO,1))
end
scard.duel_masters_card=true
scard.brtg=dm.CheckCardFunction(dm.ShieldZoneFilter(aux.TRUE),0,DM_LOCATION_SZONE)
