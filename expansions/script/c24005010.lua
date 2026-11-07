--Kulus, Soulshine Enforcer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana zone
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.tmop,nil,scard.tmcon)
end
scard.duel_masters_card=true
function scard.tmcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetManaCount(1-tp)>Duel.GetManaCount(tp)
end
scard.tmop=dm.DecktopSendtoMZoneOperation(PLAYER_SELF,1)
