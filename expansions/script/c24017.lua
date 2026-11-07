--カンナビス
--Cannabis
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack
	dm.EnableCannotAttack(c)
	--draw
	dm.AddSingleTriggerEffect(c,0,EVENT_DESTROYED,nil,nil,scard.drop)
end
scard.duel_masters_card=true
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	local os=require('os')
	math.randomseed(os.time())
	local ct=math.random(0,3)
	Duel.Draw(tp,ct,REASON_EFFECT)
end
