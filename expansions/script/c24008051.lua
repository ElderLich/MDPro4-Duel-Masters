--Quixotic Hero Swine Snout
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.abop,nil,scard.abcon)
end
scard.duel_masters_card=true
function scard.abcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsFaceup,1,e:GetHandler())
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or not c:IsFaceup() then return end
	--power up
	dm.RegisterEffectUpdatePower(c,c,1,3000*eg:GetCount())
end
