--Cannon Shell
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--power up
	dm.EnableUpdatePower(c,scard.powval)
end
scard.duel_masters_card=true
function scard.powval(e,c)
	return Duel.GetShieldCount(c:GetControler())*1000
end
