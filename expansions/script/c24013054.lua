--電磁霊樹アカシック・セカンド
--Akashic Second, Electro-Spirit
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,dm.DrawTarget(PLAYER_SELF),dm.DrawOperation(PLAYER_SELF,1))
	--destroy replace (to mana zone)
	dm.AddSingleReplaceEffectDestroy(c,1,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleReplaceDestroyTarget(Card.IsAbleToMZone)
scard.repop=dm.SingleReplaceDestroyOperation(Duel.SendtoMZone,POS_FACEUP_UNTAPPED,REASON_EFFECT+REASON_REPLACE)
