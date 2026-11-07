--パルピィ・ゴービー
--Pulpy Goobie
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--blocker
	dm.EnableBlocker(c)
	--sort
	dm.AddSingleTriggerEffect(c,0,DM_EVENT_COME_INTO_PLAY,nil,nil,dm.SortDecktopOperation(PLAYER_SELF,PLAYER_SELF,5))
	--cannot attack
	dm.EnableCannotAttack(c)
end
scard.duel_masters_card=true
