--Storm Shell
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--to mana zone
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,scard.tmtg,scard.tmop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.tmfilter(c)
	return c:IsFaceup() and c:IsAbleToMZone()
end
scard.tmtg=dm.TargetCardFunction(PLAYER_OPPO,scard.tmfilter,0,DM_LOCATION_BZONE,1,1,DM_HINTMSG_TOMZONE)
scard.tmop=dm.TargetCardsOperation(Duel.SendtoMZone,POS_FACEUP_UNTAPPED,REASON_EFFECT)
