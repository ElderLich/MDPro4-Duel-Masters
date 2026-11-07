--Megaria, Empress of Dread
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--get ability (slayer)
	dm.AddStaticEffectSlayer(c,DM_LOCATION_BZONE,DM_LOCATION_BZONE)
end
scard.duel_masters_card=true
