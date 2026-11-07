--邪脚護聖ブレイガー
--Breiga, the Wicked Protector
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--saver (all races)
	dm.AddReplaceEffectDestroy(c,0,scard.savetg,scard.saveop,scard.saveval)
end
scard.duel_masters_card=true
function scard.savefilter(c,tp)
	return c:IsLocation(DM_LOCATION_BZONE) and c:IsFaceup() and c:IsHasRace()
		and c:IsControler(tp) and not c:IsReason(REASON_REPLACE)
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
