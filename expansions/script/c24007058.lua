--Crath Lade, Merciless King
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (discard)
	dm.EnableTapAbility(c,0,scard.dhtg,scard.dhop)
end
scard.duel_masters_card=true
scard.dhtg=dm.CheckCardFunction(aux.TRUE,0,LOCATION_HAND)
scard.dhop=dm.DiscardOperation(PLAYER_OPPO,aux.TRUE,0,LOCATION_HAND,2,2,true)
