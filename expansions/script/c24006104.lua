--Living Citadel Vosh
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_COLONY_BEETLE))
	--get ability (tap ability) (to mana zone)
	dm.AddStaticEffectTapAbility(c,0,scard.tmtg1,scard.tmop,DM_LOCATION_BZONE,0,scard.tmtg2)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_COLONY_BEETLE}
function scard.tmtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanSendDecktoptoMZone(tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
scard.tmop=dm.DecktopSendtoMZoneOperation(PLAYER_SELF,1)
scard.tmtg2=aux.TargetBoolFunction(Card.IsCivilization,DM_CIVILIZATION_NATURE)
