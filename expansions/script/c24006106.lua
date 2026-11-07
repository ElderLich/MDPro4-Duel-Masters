--Mystic Treasure Chest
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--search (to mana zone)
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoMZoneOperation(PLAYER_SELF,scard.tmfilter,LOCATION_DECK,0,0,1))
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return not c:IsCivilization(DM_CIVILIZATION_NATURE)
end
