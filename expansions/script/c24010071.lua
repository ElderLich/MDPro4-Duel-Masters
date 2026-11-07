--Minelord Skyterror
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--silent skill (destroy)
	dm.EnableSilentSkill(c,0,scard.destg,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(3000)
end
scard.destg=dm.CheckCardFunction(scard.desfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE)
scard.desop=dm.DestroyOperation(nil,scard.desfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE)
