--石臼男
--Millstone Man
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (search) (to grave)
	dm.EnableTapAbility(c,0,nil,dm.SendtoGraveOperation(PLAYER_SELF,nil,0,LOCATION_DECK,1))
end
scard.duel_masters_card=true
