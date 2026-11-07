--Glory Snow
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--shield trigger
	dm.EnableShieldTrigger(c)
	--to mana zone
	dm.AddSpellCastEffect(c,0,nil,scard.tmop)
end
scard.duel_masters_card=true
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetManaCount(1-tp)>Duel.GetManaCount(tp) then
		Duel.SendDecktoptoMZone(tp,2,POS_FACEUP_UNTAPPED,REASON_EFFECT)
	end
end
