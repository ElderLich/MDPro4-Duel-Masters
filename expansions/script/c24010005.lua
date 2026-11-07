--Kejila, the Hidden Horror
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--silent skill (break)
	dm.EnableSilentSkill(c,0,scard.brtg,dm.BreakOperation(PLAYER_SELF,PLAYER_OPPO,2))
end
scard.duel_masters_card=true
scard.brtg=dm.CheckCardFunction(dm.ShieldZoneFilter(aux.TRUE),0,DM_LOCATION_SZONE)
