--Duel Masters Rules
--Not fully implemented: Tap a creature to have it attack
if not MDPro4DM then Duel.LoadScript("dm/utility.lua") end
local dm=assert(MDPro4DM,"Duel Masters runtime failed to load")
local scard,sid=dm.GetID()
function scard.initial_effect(c)
	--apply rules
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetRange(LOCATION_ALL)
	e1:SetCountLimit(1)
	e1:SetOperation(scard.operation)
	c:RegisterEffect(e1)
end
scard.duel_masters_card=true
function scard.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetFlagEffect(tp,sid)>0 or Duel.GetFlagEffect(1-tp,sid)>0 then return end
	Duel.RegisterFlagEffect(tp,sid,0,0,0)
	--position your rule card
	scard.position_rule_card(tp)
	--position opponent's rule card
	scard.position_rule_card(1-tp)
	--shuffle your deck
	scard.shuffle_deck(tp)
	--shuffle opponent's deck
	scard.shuffle_deck(1-tp)
	--check deck size
	local b1=Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)<40
	local b2=Duel.GetFieldGroupCount(1-tp,LOCATION_DECK,0)<40
	--check for non-duel masters cards
	local f=function(c)
		return not c.duel_masters_card
	end
	local b3=Duel.GetMatchingGroupCount(f,tp,LOCATION_ALL,0,nil)>0
	local b4=Duel.GetMatchingGroupCount(f,1-tp,LOCATION_ALL,0,nil)>0
	if b1 then Duel.Hint(HINT_MESSAGE,tp,DM_DECKERROR_DECKCOUNT) end
	if b2 then Duel.Hint(HINT_MESSAGE,1-tp,DM_DECKERROR_DECKCOUNT) end
	if b3 then Duel.Hint(HINT_MESSAGE,tp,DM_DECKERROR_NONDM) end
	if b4 then Duel.Hint(HINT_MESSAGE,1-tp,DM_DECKERROR_NONDM) end
	if (b1 and b2) or (b3 and b4) then
		Duel.Win(PLAYER_NONE,DM_WIN_REASON_INVALID)
		return
	elseif b1 or b3 then
		Duel.Win(1-tp,DM_WIN_REASON_INVALID)
		return
	elseif b2 or b4 then
		Duel.Win(tp,DM_WIN_REASON_INVALID)
		return
	end
	--set your lp
	Duel.SetLP(tp,1)
	--set opponent's lp
	Duel.SetLP(1-tp,1)
	--set your shields
	Duel.SendDecktoptoSZone(tp,5)
	--set opponent's shields
	Duel.SendDecktoptoSZone(1-tp,5)
	--draw your starting hand
	Duel.Draw(tp,5,REASON_RULE)
	--draw opponent's starting hand
	Duel.Draw(1-tp,5,REASON_RULE)
	--untap
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetDescription(aux.Stringid(sid,0))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(DM_EVENT_UNTAP_STEP)
	e1:SetCondition(scard.untcon1)
	e1:SetOperation(scard.untop1)
	Duel.RegisterEffect(e1,tp)
	--check for creatures that did not use "silent skill"
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_PHASE+PHASE_DRAW)
	e1b:SetCondition(scard.untcon2)
	e1b:SetOperation(scard.untop2)
	Duel.RegisterEffect(e1b,tp)
	--charge
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetDescription(aux.Stringid(sid,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetCountLimit(1)
	e2:SetOperation(scard.tmop)
	Duel.RegisterEffect(e2,tp)
	--cannot attack (summoning sickness)
	local e3=Effect.CreateEffect(c)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_ATTACK)
	e3:SetTargetRange(DM_LOCATION_BZONE,DM_LOCATION_BZONE)
	e3:SetTarget(scard.attg)
	Duel.RegisterEffect(e3,tp)
	--add description (summoning sickness)
	local e3b=Effect.CreateEffect(c)
	e3b:SetDescription(DM_DESC_SUMMONSICKNESS)
	e3b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
	e3b:SetType(EFFECT_TYPE_SINGLE)
	local e3c=Effect.CreateEffect(c)
	e3c:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e3c:SetTargetRange(DM_LOCATION_BZONE,DM_LOCATION_BZONE)
	e3c:SetTarget(scard.attg)
	e3c:SetLabelObject(e3b)
	Duel.RegisterEffect(e3c,tp)
	--cannot attack (cannot tap)
	local e4=e3:Clone()
	e4:SetTarget(aux.TargetBoolFunction(aux.NOT(Card.IsAbleToTap)))
	Duel.RegisterEffect(e4,tp)
	--add description (cannot tap)
	local e4b=Effect.CreateEffect(c)
	e4b:SetDescription(DM_DESC_CANNOTATTACK)
	e4b:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_CLIENT_HINT)
	e4b:SetType(EFFECT_TYPE_SINGLE)
	local e4c=Effect.CreateEffect(c)
	e4c:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e4c:SetTargetRange(DM_LOCATION_BZONE,DM_LOCATION_BZONE)
	e4c:SetTarget(aux.TargetBoolFunction(aux.NOT(Card.IsAbleToTap)))
	e4c:SetLabelObject(e4b)
	Duel.RegisterEffect(e4c,tp)
	--tap to attack workaround
	local e5=Effect.CreateEffect(c)
	e5:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_DAMAGE_STEP_END)
	e5:SetOperation(scard.tapop)
	Duel.RegisterEffect(e5,tp)
	--enable attack player
	local e6=Effect.CreateEffect(c)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetCode(EFFECT_DIRECT_ATTACK)
	e6:SetTargetRange(DM_LOCATION_BZONE,DM_LOCATION_BZONE)
	e6:SetTarget(aux.TargetBoolFunction(Card.IsCanAttackPlayer))
	Duel.RegisterEffect(e6,tp)
	--destroy 0 power
	local e7=Effect.CreateEffect(c)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetCode(EVENT_ADJUST)
	e7:SetOperation(scard.desop1)
	Duel.RegisterEffect(e7,tp)
	--resolved spell to grave
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e8:SetCode(EVENT_CHAINING)
	e8:SetOperation(aux.chainreg)
	Duel.RegisterEffect(e8,tp)
	local e9=e8:Clone()
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_CHAIN_SOLVED)
	e9:SetOperation(scard.tgop1)
	Duel.RegisterEffect(e9,tp)
	--win game
	local e10=Effect.CreateEffect(c)
	e10:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e10:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_ADJUST)
	e10:SetOperation(scard.winop)
	Duel.RegisterEffect(e10,tp)
	--override yugioh rules
	--attack first turn
	scard.attack_first_turn(c,tp)
	--cannot summon
	scard.cannot_summon(c,tp)
	--cannot mset
	scard.cannot_mset(c,tp)
	--monster sset
	scard.monster_sset(c,tp)
	--cannot sset
	scard.cannot_sset(c,tp)
	--cannot trigger
	scard.cannot_trigger(c,tp)
	--infinite hand
	scard.infinite_hand(c,tp)
	--infinite attacks
	scard.infinite_attacks(c,tp)
	--skip main phase 2
	scard.skip_main_phase2(c,tp)
	--cannot change position
	scard.cannot_change_position(c,tp)
	--no battle damage
	scard.avoid_battle_damage(c,tp)
	--set def equal to atk
	scard.def_equal_atk(c,tp)
	--destroy equal/less def
	scard.destroy_equal_less_def(c,tp)
	--to grave redirect
	scard.to_grave_redirect(c,tp)
	--set chain limit
	scard.set_chain_limit(c,tp)
	--cannot replay
	scard.cannot_replay(c,tp)
	--set cost equal to civilization sum
	scard.play_cost_equal_civ_sum(c,tp)
end
function scard.position_rule_card(tp)
	local g=Duel.GetMatchingGroup(Card.IsCode,tp,LOCATION_ALL,0,nil,sid)
	if g:GetCount()>0 then
		Duel.MoveToField(g:GetFirst(),tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	else
		local rule=Duel.CreateToken(tp,sid)
		Duel.MoveToField(rule,tp,tp,LOCATION_SZONE,POS_FACEUP,true)
	end
end
function scard.shuffle_deck(tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	Duel.SendtoDeck(g,PLAYER_OWNER,DECK_SEQUENCE_SHUFFLE,REASON_RULE)
	Duel.ShuffleDeck(tp)
end
--untap
function scard.untfilter1(c)
	return c:IsFaceup() and c:IsAbleToUntapStartStep() and Duel.IsPlayerCanUntapStartStep(Duel.GetTurnPlayer())
		and not c:IsHasEffect(DM_EFFECT_SILENT_SKILL)
end
function scard.untfilter2(c)
	return c:IsAbleToUntapStartStep() and Duel.IsPlayerCanUntapStartStep(Duel.GetTurnPlayer())
end
function scard.untcon1(e)
	local turnp=Duel.GetTurnPlayer()
	return Duel.IsExistingMatchingCard(scard.untfilter1,turnp,DM_LOCATION_BZONE,0,1,nil)
		or Duel.IsExistingMatchingCard(dm.ManaZoneFilter(scard.untfilter2),turnp,DM_LOCATION_MZONE,0,1,nil)
end
function scard.untop1(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local g1=Duel.GetMatchingGroup(scard.untfilter1,turnp,DM_LOCATION_BZONE,0,nil)
	local g2=Duel.GetMatchingGroup(dm.ManaZoneFilter(scard.untfilter2),turnp,DM_LOCATION_MZONE,0,nil)
	g1:Merge(g2)
	Duel.Untap(g1,REASON_RULE)
	--raise event for "When each player untaps his cards at the start of his turn"
	Duel.RaiseEvent(g1,EVENT_CUSTOM+DM_EVENT_UNTAP_START_STEP,e,0,0,0,0)
end
--check for creatures that did not use "silent skill"
function scard.untfilter3(c)
	return c:IsFaceup() and c:IsAbleToUntap() and c:IsHasEffect(DM_EFFECT_SILENT_SKILL)
		and c:GetFlagEffect(DM_EFFECT_SILENT_SKILL)==0
end
function scard.untcon2(e)
	return Duel.IsExistingMatchingCard(scard.untfilter3,Duel.GetTurnPlayer(),DM_LOCATION_BZONE,0,1,nil)
end
function scard.untop2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.untfilter3,Duel.GetTurnPlayer(),DM_LOCATION_BZONE,0,nil)
	Duel.Untap(g,REASON_RULE)
	--raise event for "When each player untaps his cards at the start of his turn"
	Duel.RaiseEvent(g,EVENT_CUSTOM+DM_EVENT_UNTAP_START_STEP,e,0,0,0,0)
end
--charge
function scard.tmop(e,tp,eg,ep,ev,re,r,rp)
	local turnp=Duel.GetTurnPlayer()
	local g=Duel.GetMatchingGroup(Card.IsAbleToMZone,turnp,LOCATION_HAND,0,nil)
	if g:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,turnp,DM_HINTMSG_TOMZONE)
	local sg=g:Select(turnp,0,1,nil)
	Duel.SendtoMZone(sg,POS_FACEUP_UNTAPPED,REASON_RULE)
end
--cannot attack (summoning sickness)
function scard.attg(e,c)
	return c:IsStatus(DM_STATUS_TO_BZONE_TURN) and not c:IsCanAttackTurn()
end
--tap to attack workaround
function scard.tapop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	if a:IsRelateToBattle() then
		Duel.Tap(a,REASON_RULE)
	end
	--part of workaround to not tap a creature that untaps itself with an ability
	--Note: Remove this if YGOPro allows a creature to tap itself for EFFECT_ATTACK_COST
	a:ResetFlagEffect(DM_EFFECT_IGNORE_TAP)
end
--destroy 0 power
function scard.desfilter(c)
	return c:IsFaceup() and c:GetPower()<=0 and not c:IsStatus(STATUS_DESTROY_CONFIRMED)
end
function scard.desop1(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(scard.desfilter,0,DM_LOCATION_BZONE,DM_LOCATION_BZONE,nil)
	if Duel.Destroy(g,REASON_RULE)>0 then
		Duel.Readjust()
	end
end
--resolved spell to grave
function scard.tgop1(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if not rc:IsSpell() or not rc:IsLocation(LOCATION_HAND) or e:GetHandler():GetFlagEffect(1)==0 then return end
	if re:IsHasCategory(DM_CATEGORY_SHIELD_TRIGGER) and Duel.IsPlayerAffectedByEffect(rp,DM_EFFECT_DONOT_DISCARD_SHIELD_TRIGGER) then return end
	if (re:IsHasProperty(DM_EFFECT_FLAG_CHARGE) or rc:IsHasEffect(DM_EFFECT_CHARGER)) and rc:IsAbleToMZone() then
		Duel.SendtoMZone(rc,POS_FACEUP_UNTAPPED,REASON_RULE)
	elseif rc:IsHasEffect(DM_EFFECT_CHARGE_TAPPED) and rc:IsAbleToMZone() then
		Duel.SendtoMZone(rc,POS_FACEUP_TAPPED,REASON_RULE)
	else
		Duel.DMSendtoGrave(rc,REASON_RULE)
	end
end
--win game
function scard.winop(e,tp,eg,ep,ev,re,r,rp)
	local win={}
	win[0]=Duel.GetFieldGroupCount(0,LOCATION_DECK,0)==0
	win[1]=Duel.GetFieldGroupCount(1,LOCATION_DECK,0)==0
	if win[0] and win[1] then
		Duel.Win(PLAYER_NONE,DM_WIN_REASON_DECKOUT)
	elseif win[0] then
		Duel.Win(1,DM_WIN_REASON_DECKOUT)
	elseif win[1] then
		Duel.Win(0,DM_WIN_REASON_DECKOUT)
	end
end
--override yugioh rules
--attack first turn
function scard.attack_first_turn(c,tp)
	if EFFECT_BP_FIRST_TURN then
		local e1=Effect.CreateEffect(c)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_BP_FIRST_TURN)
		e1:SetTargetRange(1,1)
		Duel.RegisterEffect(e1,tp)
	end
end
--cannot summon
function scard.cannot_summon(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,tp)
end
--cannot mset
function scard.cannot_mset(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_MSET)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,tp)
end
--monster sset
function scard.monster_sset(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsCreature))
	e1:SetValue(TYPE_SPELL)
	Duel.RegisterEffect(e1,tp)
end
--cannot sset
function scard.cannot_sset(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SSET)
	e1:SetTargetRange(1,1)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsLocation,LOCATION_HAND))
	Duel.RegisterEffect(e1,tp)
end
--cannot trigger
function scard.cannot_trigger(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_TRIGGER)
	e1:SetTargetRange(LOCATION_SZONE,LOCATION_SZONE)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsFacedown))
	Duel.RegisterEffect(e1,tp)
end
--infinite hand
function scard.infinite_hand(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_HAND_LIMIT)
	e1:SetTargetRange(1,1)
	e1:SetValue(MAX_NUMBER)
	Duel.RegisterEffect(e1,tp)
end
--infinite attacks
function scard.infinite_attacks(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_EXTRA_ATTACK)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(MAX_NUMBER)
	Duel.RegisterEffect(e1,tp)
end
--skip main phase 2
function scard.skip_main_phase2(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_PLAYER_TARGET)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SKIP_M2)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,tp)
end
--cannot change position
function scard.cannot_change_position(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_CHANGE_POSITION)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	Duel.RegisterEffect(e1,tp)
end
--no battle damage
function scard.avoid_battle_damage(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(1)
	Duel.RegisterEffect(e1,tp)
end
--set def equal to atk
function scard.def_equal_atk(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SET_BASE_DEFENSE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetValue(function(e,c)
		return c:GetPower()
	end)
	Duel.RegisterEffect(e1,tp)
end
--destroy equal/less def
function scard.destroy_equal_less_def(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetDescription(aux.Stringid(sid,2))
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_DAMAGE_STEP_END)
	e1:SetOperation(scard.desop2)
	Duel.RegisterEffect(e1,tp)
end
function scard.desop2(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not a or not a:IsLocation(LOCATION_MZONE) or not d or not d:IsLocation(LOCATION_MZONE) or not d:IsDefensePos() then return end
	local ab1=a:IsHasEffect(EFFECT_INDESTRUCTIBLE) or a:IsHasEffect(EFFECT_INDESTRUCTIBLE_BATTLE)
	local ab2=d:IsHasEffect(EFFECT_INDESTRUCTIBLE) or d:IsHasEffect(EFFECT_INDESTRUCTIBLE_BATTLE)
	local g=Group.CreateGroup()
	local wc=nil
	local lc=nil
	if a:GetAttack()<d:GetDefense() then
		if not ab1 and a:IsRelateToBattle() then g:AddCard(a) wc=d lc=a end
	elseif a:GetAttack()==d:GetDefense() then
		if not ab1 and a:IsRelateToBattle() then g:AddCard(a) end
		if not ab2 and d:IsRelateToBattle() then g:AddCard(d) end
	end
	if wc then
		--raise event for "When this creature wins a battle"
		Duel.RaiseSingleEvent(wc,EVENT_CUSTOM+DM_EVENT_WIN_BATTLE,e,0,0,0,0)
		--raise event for "Whenever one of your creatures wins a battle"
		Duel.RaiseEvent(wc,EVENT_CUSTOM+DM_EVENT_WIN_BATTLE,e,0,0,0,0)
	end
	if lc then
		--raise event for "When this creature loses a battle"
		Duel.RaiseSingleEvent(lc,EVENT_CUSTOM+DM_EVENT_LOSE_BATTLE,e,0,0,0,0)
		--raise event for "Whenever one of your creatures loses a battle"
		--Duel.RaiseEvent(lc,EVENT_CUSTOM+DM_EVENT_LOSE_BATTLE,e,0,0,0,0) --reserved
	end
	Duel.Destroy(g,REASON_BATTLE+REASON_RULE)
	--raise events because EVENT_DESTROYED will not trigger if REASON_BATTLE is included
	local og=Duel.GetOperatedGroup()
	for oc in aux.Next(og) do
		--raise event for "When this creature is destroyed"
		Duel.RaiseSingleEvent(oc,EVENT_DESTROYED,e,REASON_BATTLE,0,0,0)
	end
	--raise event for "Whenever another creature is destroyed"
	Duel.RaiseEvent(og,EVENT_DESTROYED,e,REASON_BATTLE,0,0,0)
end
--to grave redirect
function scard.to_grave_redirect(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE+EFFECT_FLAG_IGNORE_RANGE)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TO_GRAVE_REDIRECT)
	e1:SetTargetRange(LOCATION_ALL,LOCATION_ALL)
	e1:SetTarget(scard.tgtg)
	e1:SetValue(DM_LOCATION_GRAVE)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_SET_AVAILABLE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_LEAVE_FIELD)
	e2:SetCondition(scard.tgcon)
	e2:SetOperation(scard.tgop2)
	Duel.RegisterEffect(e2,tp)
end
function scard.tgtg(e,c)
	return c:IsReason(REASON_DESTROY+REASON_BATTLE) and not c:IsHasEffect(DM_EFFECT_TO_GRAVE_REDIRECT)
end
function scard.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsHasSource,1,nil)
end
function scard.tgop2(e,tp,eg,ep,ev,re,r,rp)
	for ec in aux.Next(eg) do
		local g=ec:GetSourceGroup():Filter(Card.DMIsAbleToGrave,nil)
		Duel.DMSendtoGrave(g,REASON_RULE)
	end
end
--set chain limit
function scard.set_chain_limit(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAINING)
	e1:SetOperation(scard.chop)
	Duel.RegisterEffect(e1,tp)
end
function scard.chop(e,tp,eg,ep,ev,re,r,rp)
	if re:IsHasProperty(DM_EFFECT_FLAG_CHAIN_LIMIT) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
--cannot replay
function scard.cannot_replay(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
		return eg:IsExists(Card.IsPreviousLocation,1,nil,LOCATION_ONFIELD) and Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE)
	end)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local a=Duel.GetAttacker()
		local d=Duel.GetAttackTarget()
		--[[if not d or not d:IsLocation(LOCATION_MZONE) then
			Duel.Tap(a,REASON_RULE)
			return
		end]]
		Duel.ChangeAttackTarget(d)
	end)
	Duel.RegisterEffect(e1,tp)
end
--set cost equal to civilization sum
function scard.play_cost_equal_civ_sum(c,tp)
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE+EFFECT_FLAG_IGNORE_RANGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_ADJUST)
	e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp)
		local f=function(c)
			return c:GetPlayCost()<c:GetCivilizationCount()
		end
		local g=Duel.GetMatchingGroup(f,0,LOCATION_ALL,LOCATION_ALL,nil)
		if g:GetCount()==0 then return end
		for tc in aux.Next(g) do
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(DM_EFFECT_UPDATE_PLAY_COST)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
			e1:SetValue(tc:GetCivilizationCount()-tc:GetPlayCost())
			tc:RegisterEffect(e1)
		end
		Duel.Readjust()
	end)
	Duel.RegisterEffect(e1,tp)
end
--[[
	References
		1. A creature that has a power 0 or less is immediately destroyed
			- Call of Darkness
			https://github.com/Fluorohydride/ygopro-scripts/blob/9c40273/c78637313.lua#L12
			- Rivalry of Warlords
			https://github.com/Fluorohydride/ygopro-scripts/blob/55de4af/c90846359.lua#L14
		2. You win the game when your opponent has no cards left in their deck
			- Ghostrick Angel of Mischief
			https://github.com/Fluorohydride/ygopro-scripts/blob/master/c53334641.lua#L10
		3. Rule: A card sent to the graveyard is banished instead
			- Macro Cosmos
			https://github.com/Fluorohydride/ygopro-scripts/blob/2fcfdf8/c30241314.lua#L16
		4. A card that costs 0, or costs below the amount of civilizations printed on the card can't be used at all
		https://duelmasters.fandom.com/wiki/Cost_Reduction#Rules
]]
