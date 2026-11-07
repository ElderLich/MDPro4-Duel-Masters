--Static Warp
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	dm.EnableSpellAttribute(c)
	--tap
	dm.AddSpellCastEffect(c,0,scard.postg,scard.posop,EFFECT_FLAG_CARD_TARGET)
end
scard.duel_masters_card=true
function scard.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,DM_HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsFaceup,tp,DM_LOCATION_BZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,1-tp,DM_HINTMSG_TARGET)
	Duel.SelectTarget(1-tp,Card.IsFaceup,1-tp,DM_LOCATION_BZONE,0,1,1,nil)
end
function scard.posfilter(c)
	return c:IsFaceup() and c:IsAbleToTap()
end
function scard.posop(e,tp,eg,ep,ev,re,r,rp)
	local g1=Duel.GetMatchingGroup(scard.posfilter,tp,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil)
	local g2=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	g1:Sub(g2)
	Duel.Tap(g1,REASON_EFFECT)
end
--[[
	References
		1. The Shallow Grave
		https://github.com/Fluorohydride/ygopro-scripts/blob/2f8b6d0/c43434803.lua#L16
]]
