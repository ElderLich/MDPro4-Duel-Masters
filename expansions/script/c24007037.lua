--Astronaut Skyterror
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--power attacker
	dm.EnablePowerAttacker(c,4000,scard.abcon)
	dm.AddEffectDescription(c,0,scard.abcon)
	--double breaker
	dm.EnableBreaker(c,DM_EFFECT_DOUBLE_BREAKER,scard.abcon)
	dm.AddEffectDescription(c,1,scard.abcon)
end
scard.duel_masters_card=true
function scard.abcon(e)
	return not Duel.IsExistingMatchingCard(Card.IsFaceup,e:GetHandlerPlayer(),DM_LOCATION_BZONE,0,1,e:GetHandler())
end
