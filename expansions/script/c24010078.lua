--Vorg's Engine
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--silent skill (destroy)
	dm.EnableSilentSkill(c,0,scard.destg,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c)
	return c:IsFaceup() and c:IsPowerBelow(2000)
end
scard.destg=dm.CheckCardFunction(scard.desfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE)
scard.desop=dm.DestroyOperation(nil,scard.desfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE)
