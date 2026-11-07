--ヘル・スラッシュ
--Hell Slash
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--search (to grave)
	dm.AddSpellCastEffect(c,0,nil,dm.SendtoGraveOperation(PLAYER_SELF,nil,0,LOCATION_DECK,0,3))
end
scard.duel_masters_card=true
