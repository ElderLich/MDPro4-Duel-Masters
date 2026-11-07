--爛漫妖精フリップル
--Flipull, Full Bloom Faerie
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana zone
	dm.AddTriggerEffect(c,0,EVENT_PHASE+PHASE_END,nil,nil,scard.tmop,nil,scard.tmcon)
end
scard.duel_masters_card=true
scard.tmcon=dm.TurnPlayerCondition(PLAYER_SELF)
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsAbleToMZone()
end
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.tmfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil):RandomSelect(tp,1)
	Duel.HintSelection(g)
	Duel.SendtoMZone(g,POS_FACEUP_UNTAPPED,REASON_EFFECT)
end
