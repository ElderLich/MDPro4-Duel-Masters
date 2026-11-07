--Skullcutter, Swarm Leader
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.EnableTurnEndSelfDestroy(c,0,scard.descon)
end
scard.duel_masters_card=true
function scard.descon(e)
	return Duel.GetFieldGroupCount(e:GetHandlerPlayer(),DM_LOCATION_BZONE,0)==1
end
