--Jack Viper, Shadow of Doom
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--evolution
	dm.AddEvolutionProcedure(c,aux.FilterBoolFunction(Card.DMIsEvolutionRace,DM_RACE_GHOST))
	--destroy replace (return)
	dm.AddReplaceEffectDestroy(c,0,scard.reptg,scard.repop,scard.repval)
end
scard.duel_masters_card=true
scard.evolution_race_list={DM_RACE_GHOST}
function scard.repfilter(c,tp)
	return c:IsLocation(DM_LOCATION_BZONE) and c:IsFaceup() and c:IsCivilization(DM_CIVILIZATION_DARKNESS)
		and c:IsControler(tp) and not c:IsReason(REASON_REPLACE) and c:IsAbleToHand()
end
function scard.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:IsExists(scard.repfilter,1,c,tp) end
	local g=eg:Filter(scard.repfilter,c,tp)
	if Duel.SelectYesNo(tp,aux.Stringid(sid,1)) then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	else return false end
end
function scard.repval(e,c)
	return scard.repfilter(c,e:GetHandlerPlayer())
end
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SendtoHand(e:GetLabelObject(),PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
end
