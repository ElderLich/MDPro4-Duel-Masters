--妖魔賢者メルカプ
--Melcap, the Mutant Explorer
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap
	dm.AddSingleTriggerEffect(c,0,EVENT_BATTLE_CONFIRM,nil,nil,scard.posop,nil,scard.poscon)
end
scard.duel_masters_card=true
scard.poscon=aux.AND(dm.UnblockedCondition,dm.AttackPlayerCondition)
scard.posop=dm.TapOperation(nil,Card.IsFaceup,0,DM_LOCATION_BZONE)
