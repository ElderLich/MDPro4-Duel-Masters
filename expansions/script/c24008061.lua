--スケルトン･バイス
--Skeleton Vice
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--discard
	dm.AddSpellCastEffect(c,0,nil,dm.DiscardOperation(PLAYER_OPPO,aux.TRUE,0,LOCATION_HAND,2,2,true))
end
scard.duel_masters_card=true
