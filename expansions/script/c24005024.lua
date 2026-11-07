--Split-Head Hydroturtle Q
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--survivor (draw)
	dm.AddSingleTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.drtg1,scard.drop)
	dm.AddSingleGrantTriggerEffect(c,0,EVENT_ATTACK_ANNOUNCE,true,scard.drtg1,scard.drop,nil,LOCATION_ALL,0,scard.drtg2)
end
scard.duel_masters_card=true
function scard.drtg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.Hint(HINT_OPSELECTED,1-tp,e:GetDescription())
end
scard.drop=dm.DrawOperation(PLAYER_SELF,1)
scard.drtg2=dm.TargetBoolFunctionExceptSelf(Card.DMIsRace,DM_RACE_SURVIVOR)
