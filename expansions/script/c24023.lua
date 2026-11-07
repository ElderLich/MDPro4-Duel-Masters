--ゲットのスリング
--Gett's Sling
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--destroy
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,scard.destg,scard.desop)
end
scard.duel_masters_card=true
function scard.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local os=require('os')
	math.randomseed(os.time())
	local t={3000,4000,5000,6000}
	local pwr=t[math.random(#t)]
	e:SetLabel(pwr)
	Duel.Hint(HINT_NUMBER,0,pwr)
end
function scard.desfilter(c,pwr)
	return c:IsFaceup() and c:IsPowerAbove(pwr)
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.desfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil,e:GetLabel())
	Duel.Destroy(g,REASON_EFFECT)
end
