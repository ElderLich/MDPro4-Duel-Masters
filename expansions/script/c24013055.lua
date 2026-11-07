--勇猛妖魔アニマトレイン
--Animatrain, the Daring Beast
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot attack
	dm.EnableCannotAttack(c,scard.atcon)
	dm.AddEffectDescription(c,0,scard.atcon)
end
scard.duel_masters_card=true
function scard.atcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetShieldCount(tp)>Duel.GetShieldCount(1-tp)
end
