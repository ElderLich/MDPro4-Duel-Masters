--宣凶師ルベルス
--Rubels, the Explorer
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm broken shield
	dm.EnablePlayerEffectCustom(c,DM_EFFECT_CONFIRM_BROKEN_SHIELD,0,1)
end
scard.duel_masters_card=true
