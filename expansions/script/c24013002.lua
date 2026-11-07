--雷炎賢者エイジス
--Aegis, Sage of Fire and Lightning
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack player
	dm.EnableCannotAttackPlayer(c)
	--destroy
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_BATTLE_END,nil,scard.destg,scard.desop,nil,scard.descon)
end
scard.duel_masters_card=true
scard.descon=aux.AND(dm.SelfBlockCondition,dm.SelfBattleWinCondition)
function scard.desfilter(c,race)
	return c:IsFaceup() and c:DMIsRace(race)
end
function scard.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local bc=e:GetHandler():GetBattleTarget()
	e:SetLabel(bc:DMGetRace())
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.desfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil,e:GetLabel())
	Duel.Destroy(g,REASON_EFFECT)
end
