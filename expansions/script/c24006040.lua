--Neon Cluster
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (draw)
	dm.EnableTapAbility(c,0,dm.DrawTarget(PLAYER_SELF),dm.DrawOperation(PLAYER_SELF,2))
end
scard.duel_masters_card=true
