--Turtle Horn, the Imposing
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--search (to hand)
	dm.AddTriggerEffectPlayerUseShieldTrigger(c,0,PLAYER_OPPO,nil,nil,dm.SendtoHandOperation(PLAYER_SELF,Card.IsCreature,LOCATION_DECK,0,0,1,true))
end
scard.duel_masters_card=true
