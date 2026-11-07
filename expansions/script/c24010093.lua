--Terradragon Cusdalf
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,4000)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--cannot untap
	dm.EnablePlayerEffectCustom(c,DM_EFFECT_PLAYER_CANNOT_UNTAP_START_STEP,1,0)
end
scard.duel_masters_card=true
--[[
	Notes
		1. You can untap the cards in your mana zone via a card effect
		https://duelmasters.fandom.com/wiki/Terradragon_Cusdalf/Rulings
]]
