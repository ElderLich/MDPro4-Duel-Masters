--Pouch Shell
--Not fully implemented: YGOPro makes all cards under an evolution creature leave the battle zone
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to grave
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,true,scard.tgtg,scard.tgop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tgfilter(c)
	return c:IsFaceup() and c:IsEvolution() and c:IsHasSource() and c:DMIsAbleToGrave()
end
scard.tgtg=dm.TargetCardFunction(PLAYER_SELF,scard.tgfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TOGRAVE)
function scard.tgop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	local mg=tc1:GetSourceGroup()
	local pos=tc1:GetPosition()
	local seq=tc1:GetSequence()
	if not tc1:IsRelateToEffect(e) or not scard.tgfilter(tc1) then return end
	local g=Group.CreateGroup()
	for mc in aux.Next(mg) do
		g:AddCard(mc)
	end
	Duel.DMSendtoGrave(tc1,REASON_EFFECT)
	--workaround to keep stacked pile
	local tc2=g:GetFirst()
	Duel.MoveToField(tc2,tp,1-tp,DM_LOCATION_BZONE,pos,true)
	g:RemoveCard(tc2)
	Duel.MoveSequence(tc2,seq)
	if g:GetCount()>0 then
		Duel.PutOnTop(tc2,g)
	end
end
