--我狼兵ラングレン
--Langren, the Lone Wolf
local dm=require "expansions.utility_dmtcg"
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
