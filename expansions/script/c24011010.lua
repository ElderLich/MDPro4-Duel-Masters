--Lamiel, Destiny Enforcer
--Not fully implemented: If this and another creature are destroyed at the same time, you can still trigger its ability.
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--wave striker (draw)
	dm.EnableWaveStriker(c)
	dm.AddEffectDescription(c,1,dm.WaveStrikerCondition)
	dm.AddTriggerEffect(c,0,EVENT_DESTROYED,true,dm.DrawTarget(PLAYER_SELF),scard.drop,nil,aux.AND(dm.WaveStrikerCondition,scard.drcon))
end
scard.duel_masters_card=true
function scard.cfilter(c,tp)
	return c:IsCreature() and c:GetPreviousControler()==tp
end
function scard.drcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(scard.cfilter,1,nil,tp) and Duel.GetTurnPlayer()~=tp
end
function scard.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,eg:GetCount(),REASON_EFFECT)
end
