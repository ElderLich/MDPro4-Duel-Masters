--呪紋の化身
--Cursed Totem
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--cannot use shield trigger
	dm.EnablePlayerEffectCustom(c,EFFECT_CANNOT_ACTIVATE,0,1,scard.actval)
end
scard.duel_masters_card=true
function scard.actval(e,re,tp)
	return re:IsHasCategory(DM_CATEGORY_SHIELD_TRIGGER) and re:GetHandler():IsBrokenShield()
end
