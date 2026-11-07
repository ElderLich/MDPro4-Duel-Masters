--Terradragon Dakma Balgarow
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.dbcon)
	dm.AddEffectDescription(c,0,scard.dbcon)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER,scard.tbcon)
	dm.AddEffectDescription(c,1,scard.tbcon)
end
scard.duel_masters_card=true
--power up
function scard.powval(e,c)
	local p=c:GetControler()
	local ct1=Duel.GetShieldCount(p)
	local ct2=Duel.GetShieldCount(1-p)
	return (ct1+ct2)*2000
end
--double breaker
function scard.dbcon(e)
	return e:GetHandler():IsPowerAbove(6000)
end
--triple breaker
function scard.tbcon(e)
	return e:GetHandler():IsPowerAbove(15000)
end
