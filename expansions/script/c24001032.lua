--Illusionary Merfolk
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--draw
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.drop,nil,dm.ExistingCardCondition(scard.cfilter))
end
scard.duel_masters_card=true
function scard.cfilter(c)
	return c:IsFaceup() and c:DMIsRace(DM_RACE_CYBER_LORD)
end
scard.drop=dm.DrawUpToOperation(PLAYER_SELF,3)
