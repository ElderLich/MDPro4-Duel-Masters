--Soulswap
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to mana zone, to battle zone
	dm.AddSpellCastEffect(c,0,scard.tmtg,scard.tmop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsAbleToMZone()
end
scard.tmtg=dm.TargetCardFunction(PLAYER_SELF,scard.tmfilter,DM_LOCATION_BZONE,DM_LOCATION_BZONE,0,1,DM_HINTMSG_TOMZONE)
function scard.tbfilter(c,e,tp,cost)
	return c:IsCreature() and not c:IsEvolution() and c:IsManaCostBelow(cost)
		and c:IsAbleToBZone(e,0,tp,false,false) and c:IsCanBeEffectTarget(e)
end
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) or not scard.tmfilter(tc) then return end
	if Duel.SendtoMZone(tc,POS_FACEUP_UNTAPPED,REASON_EFFECT)==0 then return end
	local p=tc:GetOwner()
	local cost=Duel.GetManaCount(p)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TOBZONE)
	local g2=Duel.SelectMatchingCard(tp,dm.ManaZoneFilter(scard.tbfilter),p,DM_LOCATION_MZONE,0,1,1,nil,e,p,cost)
	if g2:GetCount()==0 then return end
	Duel.SetTargetCard(g2)
	Duel.SendtoBZone(g2,0,p,p,false,false,POS_FACEUP_UNTAPPED)
end
