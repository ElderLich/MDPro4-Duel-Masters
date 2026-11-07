--Soul Phoenix, Avatar of Unity
--[[
	Not fully implemented:
		1. The effect of Soul Phoenix leaving the battle zone is not substituted or replaced
		It should not be treated as being destroyed by effects that destroy it (same for any other removal effect)
		2. The effect of Soul Phoenix leaving the battle zone is not applied when it is added to the shield zone
]]
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--vortex evolution
	dm.EnableEffectCustom(c,DM_EFFECT_VORTEX_EVOLUTION)
	dm.AddEvolutionProcedure(c,scard.evofilter1,scard.evofilter2)
	--triple breaker
	dm.EnableBreaker(c,DM_EFFECT_TRIPLE_BREAKER)
	--leave replace (separate evolution source)
	dm.AddSingleReplaceEffectLeaveBZone(c,0,scard.repop)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_FIRE_BIRD,DM_RACE_EARTH_DRAGON,DM_RACE_DRAGON}
--vortex evolution
scard.evofilter1=aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_FIRE_BIRD)
scard.evofilter2=aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_EARTH_DRAGON)
--leave replace (separate evolution source)
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetSourceGroup()
	local pos=c:GetPreviousPosition()
	local g=Group.CreateGroup()
	g:Merge(mg)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_CARD,0,sid)
	for tc in aux.Next(g) do
		Duel.MoveToField(tc,tp,tp,DM_LOCATION_BZONE,pos,true)
	end
end
