--Hearty Cap'n Polligon
local dm=require "expansions.utility_dmtcg"
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
