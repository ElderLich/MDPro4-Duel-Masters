--Kip Chippotto
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--saver (armored dragon)
	dm.AddReplaceEffectDestroy(c,0,scard.savetg,scard.saveop,scard.saveval)
end
scard.duel_masters_card=true
function scard.savefilter(c,tp)
	return c:IsLocation(DM_LOCATION_BZONE) and c:IsFaceup() and c:DMIsRace(DM_RACE_ARMORED_DRAGON)
		and c:IsControler(tp) and not c:IsReason(REASON_BATTLE) and not c:IsReason(REASON_REPLACE)
end
function scard.savetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return eg:FilterCount(scard.savefilter,c,tp)==1 and c:IsDestructable(e) end
	return Duel.SelectYesNo(tp,aux.Stringid(sid,1))
end
function scard.saveval(e,c)
	return scard.savefilter(c,e:GetHandlerPlayer())
end
function scard.saveop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT+REASON_REPLACE)
end
--[[
	Notes
		1. The destroy replace ability does not apply to creatures that lost a battle
		https://duelmasters.fandom.com/wiki/Kip_Chippotto/Rulings
]]
