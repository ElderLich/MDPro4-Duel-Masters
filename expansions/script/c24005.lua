--ガルベリアス・ドラゴン
--Galberius Dragon
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER)
	--speed attacker
	dm.EnableEffectCustom(c,DM_EFFECT_SPEED_ATTACKER)
	--to mana zone
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.tmop,nil,scard.abcon(DM_CIVILIZATION_NATURE))
	--cannot be blocked
	dm.EnableCannotBeBlocked(c,nil,scard.abcon(DM_CIVILIZATION_WATER))
	dm.AddEffectDescription(c,2,scard.abcon(DM_CIVILIZATION_WATER))
	--slayer
	dm.EnableSlayer(c,scard.abcon(DM_CIVILIZATION_DARKNESS))
	dm.AddEffectDescription(c,3,scard.abcon(DM_CIVILIZATION_DARKNESS))
	--untap
	dm.EnableTurnEndSelfUntap(c,1,scard.abcon(DM_CIVILIZATION_LIGHT))
end
scard.duel_masters_card=true
scard.tmop=dm.DecktopSendtoMZoneOperation(PLAYER_SELF,1)
function scard.cfilter(c,civ)
	return c:IsFaceup() and c:IsCivilization(civ)
end
function scard.abcon(civ)
	return	function(e)
				return Duel.IsExistingMatchingCard(scard.cfilter,e:GetHandlerPlayer(),0,DM_LOCATION_BZONE,1,nil,civ)
			end
end
