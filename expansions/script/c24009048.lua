--Mana Bonanza
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to mana zone
	dm.AddSpellCastEffect(c,0,nil,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetManaCount(tp)
	Duel.SendDecktoptoMZone(tp,ct,POS_FACEUP_TAPPED,REASON_EFFECT)
end
