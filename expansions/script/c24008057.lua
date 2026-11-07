--Emperor Quazla
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_CYBER_LORD))
	--draw
	dm.AddTriggerEffectPlayerUseShieldTrigger(c,0,PLAYER_OPPO,nil,nil,dm.DrawUpToOperation(PLAYER_SELF,2))
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_CYBER_LORD,DM_RACE_CYBER}
