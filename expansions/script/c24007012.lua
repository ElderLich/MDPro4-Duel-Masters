--Pulsar Tree
local dm=require "expansions.utility_dmtcg"
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableCreatureAttribute(c)
	--shield saver
	dm.EnableShieldSaver(c)
end
scard.duel_masters_card=true
