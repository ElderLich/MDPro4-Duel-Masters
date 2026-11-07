--Garatyano
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--tap ability (confirm)
	dm.EnableTapAbility(c,0,scard.conftg,scard.confop)
end
scard.duel_masters_card=true
scard.conftg=dm.CheckDeckFunction(PLAYER_SELF)
scard.confop=dm.SortDecktopOperation(PLAYER_SELF,PLAYER_SELF,3)
