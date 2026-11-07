--Charmilia, the Enticer
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (search) (to hand)
	dm.EnableTapAbility(c,0,scard.thtg,scard.thop)
end
scard.duel_masters_card=true
scard.thtg=dm.CheckDeckFunction(PLAYER_SELF)
scard.thop=dm.SendtoHandOperation(PLAYER_SELF,Card.IsCreature,LOCATION_DECK,0,0,1,true)
