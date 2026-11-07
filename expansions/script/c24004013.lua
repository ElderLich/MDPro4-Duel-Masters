--Mist Rias, Sonic Guardian
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.drtg,scard.drop,nil,scard.drcon)
end
scard.duel_masters_card=true
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFaceup,1,e:GetHandler())
end
scard.drtg=dm.DrawTarget(PLAYER_SELF)
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,eg:GetCount(),REASON_EFFECT)
end
--[[
	Notes
		1. Mist Rias, Sonic Guardian does not need to remain in the battle zone to resolve its ability
		https://duelmasters.fandom.com/wiki/Mist_Rias,_Sonic_Guardian/Rulings
]]
