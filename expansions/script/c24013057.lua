--悪魔聖霊アウゼス
--Auzesu, the Demonic Holy Spirit
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--sympathy (angel command, demon command)
	dm.EnableSympathy(c,DM_RACE_ANGEL_COMMAND,DM_RACE_DEMON_COMMAND)
	--destroy
	dm.AddTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,nil,nil,scard.desop,nil,scard.descon)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
end
scard.duel_masters_card=true
function scard.descon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	return a:IsControler(tp) and a:DMIsRace(DM_RACE_ANGEL_COMMAND,DM_RACE_DEMON_COMMAND)
end
function scard.desfilter(c)
	return c:IsFaceup() and c:IsTapped()
end
scard.desop=dm.DestroyOperation(PLAYER_SELF,scard.desfilter,0,DM_LOCATION_BZONE,1)
