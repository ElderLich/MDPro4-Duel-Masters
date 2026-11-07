--Sphere of Wonder
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--to shield zone
	dm.AddSpellCastEffect(c,0,nil,scard.tsop)
end
scard.duel_masters_card=true
function scard.tsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetShieldCount(1-tp)>Duel.GetShieldCount(tp) then
		Duel.SendDecktoptoSZone(tp,1)
	end
end
