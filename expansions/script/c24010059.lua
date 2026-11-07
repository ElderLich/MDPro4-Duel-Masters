--Upheaval
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--return, to mana zone
	dm.AddSpellCastEffect(c,0,nil,scard.retop)
end
scard.duel_masters_card=true
function scard.retop(e,tp,eg,ep,ev,re,r,rp)
	scard.return_card(tp)
	scard.return_card(1-tp)
end
function scard.return_card(tp)
	local g1=Duel.GetMatchingGroup(dm.ManaZoneFilter(Card.IsAbleToHand),tp,DM_LOCATION_MZONE,0,nil)
	Duel.SendtoHand(g1,PLAYER_OWNER,REASON_EFFECT)
	local g2=Duel.GetMatchingGroup(Card.IsAbleToMZone,tp,LOCATION_HAND,0,nil)
	g2:Sub(Duel.GetOperatedGroup())
	Duel.SendtoMZone(g2,POS_FACEUP_TAPPED,REASON_EFFECT)
end
--[[
	References
		1. Morphing Jar #2
		https://github.com/Fluorohydride/ygopro-scripts/blob/b2c6aa3/c79106360.lua#L46
]]
