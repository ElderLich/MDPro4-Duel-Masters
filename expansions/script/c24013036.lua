--宣凶師ルベルス
--Rubels, the Explorer
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--confirm broken shield
	dm.EnablePlayerEffectCustom(c,DM_EFFECT_CONFIRM_BROKEN_SHIELD,0,1)
end
scard.duel_masters_card=true
