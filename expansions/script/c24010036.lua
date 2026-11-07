--Mystic Magician
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (enter tapped)
	dm.EnableEffectCustom(c,DM_EFFECT_ENTER_BZONE_TAPPED,nil,LOCATION_ALL,0,aux.TargetBoolFunction(Card.IsHasEffect,DM_EFFECT_SILENT_SKILL))
	--destroy replace (return)
	dm.AddReplaceEffectDestroy(c,0,scard.reptg,scard.repop,scard.repval)
end
scard.duel_masters_card=true
function scard.repfilter(c,tp)
	return c:IsLocation(DM_LOCATION_BZONE) and c:IsFaceup() and c:IsHasEffect(DM_EFFECT_SILENT_SKILL)
		and c:IsControler(tp) and not c:IsReason(REASON_REPLACE) and c:IsAbleToHand()
end
function scard.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(scard.repfilter,1,nil,tp) end
	local g=eg:Filter(scard.repfilter,nil,tp)
	g:KeepAlive()
	e:SetLabelObject(g)
	return true
end
function scard.repval(e,c)
	return scard.repfilter(c,e:GetHandlerPlayer())
end
function scard.repop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,sid)
	Duel.SendtoHand(e:GetLabelObject(),PLAYER_OWNER,REASON_EFFECT+REASON_REPLACE)
end
