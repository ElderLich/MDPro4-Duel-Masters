--Pangaea's Will
--Not fully implemented: YGOPro makes all cards under an evolution creature leave the battle zone
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to mana zone
	dm.AddSpellCastEffect(c,0,scard.tmtg,scard.tmop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsEvolution() and c:IsHasSource() and c:IsAbleToMZone()
end
scard.tmtg=dm.TargetCardFunction(PLAYER_SELF,scard.tmfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TOMZONE)
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local tc1=Duel.GetFirstTarget()
	local mg=tc1:GetSourceGroup()
	local pos=tc1:GetPosition()
	local seq=tc1:GetSequence()
	if not tc1:IsRelateToEffect(e) or not scard.tmfilter(tc1) then return end
	local g=Group.CreateGroup()
	for mc in aux.Next(mg) do
		g:AddCard(mc)
	end
	Duel.SendtoMZone(tc1,POS_FACEUP_UNTAPPED,REASON_EFFECT)
	--workaround to keep stacked pile
	local tc2=g:GetFirst()
	Duel.MoveToField(tc2,tp,1-tp,DM_LOCATION_BZONE,pos,true)
	g:RemoveCard(tc2)
	Duel.MoveSequence(tc2,seq)
	if g:GetCount()>0 then
		Duel.PutOnTop(tc2,g)
	end
end
