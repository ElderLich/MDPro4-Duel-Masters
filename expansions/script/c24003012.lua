--Angler Cluster
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--cannot attack
	dm.EnableCannotAttack(c)
	--power up
	dm.EnableUpdatePower(c,3000,dm.MZoneExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_WATER))
	dm.AddEffectDescription(c,0,dm.MZoneExclusiveCondition(Card.IsCivilization,DM_CIVILIZATION_WATER))
end
scard.duel_masters_card=true
