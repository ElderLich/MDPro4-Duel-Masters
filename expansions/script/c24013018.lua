--偶発と弾幕の要塞
--Fortification Against Barrage and Ambush
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--confirm (destroy, to grave)
	dm.AddSpellCastEffect(c,0,nil,scard.desop)
end
scard.duel_masters_card=true
function scard.desfilter(c,pwr)
	return c:IsFaceup() and c:GetPower()<pwr
end
function scard.desop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(Card.IsCreature,tp,LOCATION_DECK,0,nil)
	local dcount=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)
	if dcount==0 then return end
	local seq=-1
	local crcard=nil
	for tc in aux.Next(g1) do
		if tc:GetSequence()>seq then
			seq=tc:GetSequence()
			crcard=tc
		end
	end
	if seq==-1 then
		Duel.ConfirmDecktop(tp,dcount)
		Duel.DMSendDecktoptoGrave(tp,dcount-seq,REASON_EFFECT)
		return
	end
	Duel.ConfirmDecktop(tp,dcount-seq)
	if crcard:IsCreature() then
		local g2=Duel.GetMatchingGroup(scard.desfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil,crcard:GetPower())
		Duel.Destroy(g2,REASON_EFFECT)
	end
	Duel.DisableShuffleCheck()
	Duel.DMSendDecktoptoGrave(tp,dcount-seq,REASON_EFFECT)
end
