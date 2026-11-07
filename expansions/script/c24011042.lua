--Hazard Hopper
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--return
	dm.EnableTurnEndSelfReturn(c,0,scard.retcon)
end
scard.duel_masters_card=true
function scard.retcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetBrokenShieldCount()>0 and Duel.GetTurnPlayer()==tp
end
