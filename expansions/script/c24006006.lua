--Tank Mutant
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (destroy)
	dm.EnableTapAbility(c,0,scard.destg,scard.desop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
scard.destg=dm.TargetCardFunction(PLAYER_OPPO,Card.IsFaceup,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_DESTROY)
scard.desop=dm.TargetCardsOperation(Duel.Destroy,REASON_EFFECT)
