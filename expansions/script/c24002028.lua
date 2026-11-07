--Gigastand
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy replace (return, discard)
	dm.AddSingleReplaceEffectDestroy(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleReplaceDestroyTarget2(1,Card.IsAbleToHand)
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SendtoHand(e:GetHandler(),PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
	Duel.ShuffleHand(tp)
	Duel.DiscardHand(tp,aux.TRUE,1,1,REASON_EFFECT)
end
