--Venom Worm
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (get ability)
	dm.EnableTapAbility(c,0,nil,scard.abop)
end
scard.duel_masters_card=true
function scard.abfilter(c,race)
	return c:IsFaceup() and c:DMIsRace(race)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RACE)
	local race=Duel.DMAnnounceRace(tp)
	local g=Duel.GetMatchingGroup(scard.abfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil,race)
	if g:GetCount()==0 then return end
	for tc in aux.Next(g) do
		--slayer
		dm.RegisterEffectSlayer(e:GetHandler(),tc,1)
	end
end
