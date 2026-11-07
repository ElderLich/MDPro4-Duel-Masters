--Sky Crusher, the Agitator
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (to grave)
	dm.EnableTapAbility(c,0,scard.tgtg,scard.tgop)
end
scard.duel_masters_card=true
scard.tgtg=dm.CheckCardFunction(dm.ManaZoneFilter(Card.DMIsAbleToGrave),DM_LOCATION_MZONE,DM_LOCATION_MZONE)
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	dm.SendtoGraveOperation(PLAYER_SELF,dm.ManaZoneFilter(),DM_LOCATION_MZONE,0,1)(e,tp,eg,ep,ev,re,r,rp)
	dm.SendtoGraveOperation(PLAYER_OPPO,dm.ManaZoneFilter(),0,DM_LOCATION_MZONE,1)(e,tp,eg,ep,ev,re,r,rp)
end
