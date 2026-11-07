--Aqua Agent
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--stealth (water)
	dm.EnableStealth(c,DM_CIVILIZATION_WATER)
	--destroy replace (return)
	dm.AddSingleReplaceEffectDestroy(c,0,scard.reptg,scard.repop)
end
scard.duel_masters_card=true
scard.reptg=dm.SingleReplaceDestroyTarget2(1,Card.IsAbleToHand)
scard.repop=dm.SingleReplaceDestroyOperation(Duel.SendtoHand,PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
