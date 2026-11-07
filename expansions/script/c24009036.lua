--Aerodactyl Kooza
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,nil,scard.actcon)
	--power attacker
	dm.EnablePowerAttacker(c,3000)
end
scard.duel_masters_card=true
function scard.actcon(e)
	local d=Duel.GetAttackTarget()
	return d and d:IsFaceup()
end
