--結界の守護者クレス・ドーベル
--Creis Dober, Barrier Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--get ability
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_BATTLE_END,nil,nil,scard.abop,nil,scard.abcon)
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:IsEvolution()
end
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	return dm.SelfBlockCondition(e,tp,eg,ep,ev,re,r,rp)
		and Duel.IsExistingMatchingCard(scard.cfilter,tp,0,DM_LOCATION_BZONE,1,nil)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	--power up
	dm.RegisterEffectUpdatePower(c,c,1,4000,0,0)
end
