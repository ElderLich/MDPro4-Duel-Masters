--Petrova, Channeler of Suns
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,scard.abop)
	--cannot be targeted
	dm.EnableCannotBeTargeted(c)
end
scard.duel_masters_card=true
--function used to find a particular item in a list
local function tablefind(t,el)
	for i,v in pairs(t) do
		if v==el then
			return i
		end
	end
end
--get ability
function scard.abfilter(c,race)
	return c:IsFaceup() and c:DMIsRace(race)
end
function scard.abop(e,tp,eg,ep,ev,re,r,rp)
	local t1=dm.race_desc_list
	local t2=dm.race_value_list
	local item1=tablefind(t1,DM_SELECT_RACE_MECHA_DEL_SOL)
	local item2=tablefind(t2,DM_RACE_MECHA_DEL_SOL)
	table.remove(t1,item1)
	table.remove(t2,item2)
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_RACE)
	local race=Duel.DMAnnounceRace(tp)
	table.insert(t1,1,DM_SELECT_RACE_MECHA_DEL_SOL)
	table.insert(t2,1,DM_RACE_MECHA_DEL_SOL)
	--power up
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetDescription(aux.Stringid(sid,1))
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(DM_EFFECT_UPDATE_POWER)
	e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
	e1:SetValue(4000)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e2:SetTargetRange(DM_LOCATION_BZONE,DM_LOCATION_BZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.DMIsRace,race))
	e2:SetLabelObject(e1)
	Duel.RegisterEffect(e2,tp)
	--reset power up
	local e3=Effect.CreateEffect(e:GetHandler())
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_ADJUST)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e3:SetCountLimit(1)
	e3:SetLabelObject(e2)
	e3:SetCondition(scard.rstcon)
	e3:SetOperation(scard.rstop)
	Duel.RegisterEffect(e3,tp)
end
function scard.rstcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return not c:IsLocation(DM_LOCATION_BZONE) or not c:IsFaceup()
end
function scard.rstop(e,tp,eg,ep,ev,re,r,rp)
	local e1=e:GetLabelObject()
	e1:Reset()
	e:Reset()
end
--[[
	Notes
		1. The power increase effect lasts as long as Petrova, Channeler of Suns is in the battle zone
		https://duelmasters.fandom.com/wiki/Petrova,_Channeler_of_Suns/Rulings
]]
