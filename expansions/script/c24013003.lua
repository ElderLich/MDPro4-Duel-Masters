--電磁旋竜アカシック・ファースト
--Akashic First, Electro-Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--sympathy (cyber virus, dragonoid)
	dm.EnableSympathy(c,DM_RACE_CYBER_VIRUS,DM_RACE_DRAGO_NOID)
	--attack untapped
	dm.EnableAttackUntapped(c)
	--destroy replace (return)
	dm.AddSingleReplaceEffectDestroy(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleReplaceDestroyTarget(Card.IsAbleToHand)
scard.repop=dm.SingleReplaceDestroyOperation(Duel.SendtoHand,PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
