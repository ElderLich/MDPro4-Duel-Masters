--我狼兵ラングレン
--Langren, the Lone Wolf
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack
	dm.EnableCannotAttack(c,scard.atcon)
	dm.AddEffectDescription(c,0,scard.atcon)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsUntapped()
end
function scard.atcon(e)
	return Duel.IsExistingMatchingCard(scard.cfilter,e:GetHandlerPlayer(),DM_LOCATION_BZONE,DM_LOCATION_BZONE,1,e:GetHandler())
end
