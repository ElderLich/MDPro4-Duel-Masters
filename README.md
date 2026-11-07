# YGOPro-DM

<p align="center">
	<img src="https://user-images.githubusercontent.com/18324297/34651382-49c5daba-f3d8-11e7-9222-1488ac1761d8.png">
</p>

## How to install
1. Exit [YGOPro](https://github.com/Fluorohydride/ygopro).
2. Put the following folders in YGOPro's main folder. **Make a backup of the original files, if you do not want to overwrite them**:<br>
● deck<br>
● expansions<br>
● textures
3. Optional: Click [here](https://mega.nz/#F!5RAFSIYb!nF8pJNkmZk4TzwMGtiX8Xw) to download card pics. Put all card pics in expansions\pics.

## How to play
1. Start YGOPro.
2. Click on `Deck Management` to build your deck. Remember to add 1 _Duel Masters Rules_!<br>
If you do not build your deck according to the following rules, you will lose the game and have to rebuild your deck:<br>
● Your deck must be exactly 40 cards.<br>
● All 40 cards must be [Duel Masters](https://duelmasters.fandom.com/wiki/Card) cards. You cannot have any non-Duel Masters cards in your deck.
3. Enable `Auto shield placement` or `Auto Spell/Trap Card placement` in the Settings menu so YGOPro will not tell you the names of the cards to set as shields.
4. At the start of the game, take 5 cards from the top of your deck without [looking](https://duelmasters.fandom.com/wiki/Look) at them and put them in a row in front of you face down. These face down cards are your [shields](https://duelmasters.wikia.com/wiki/Shield). (You can only have a maximum of 5 shields in YGOPro.) Then [draw](https://duelmasters.fandom.com/wiki/Draw) 5 cards. There is no limit to the number of cards you can have in your hand.
5. During your [Start of Turn Step](https://duelmasters.fandom.com/wiki/Start_of_Turn_Step), [untap](https://duelmasters.fandom.com/wiki/Tap_(Untap)) all your [tapped](https://duelmasters.fandom.com/wiki/Tap_(Untap)) creatures in the [battle zone](https://duelmasters.fandom.com/wiki/Battle_Zone) and tapped cards in your [mana zone](https://duelmasters.fandom.com/wiki/Mana_Zone).
6. During your [Draw Step](https://duelmasters.fandom.com/wiki/Draw_Step), draw 1 card. The person who plays first skips drawing a card on their first turn.
7. During your [Charge Step](https://duelmasters.fandom.com/wiki/Charge_Step), you can put a card from your hand into your mana zone. There is no limit to the number of cards you can have in your mana zone.
8. During your [Main Step](https://duelmasters.fandom.com/wiki/Main_Step), you can [play](https://duelmasters.fandom.com/wiki/Play) as many [creatures](https://duelmasters.fandom.com/wiki/Creature), [spells](https://duelmasters.fandom.com/wiki/Spell), [cross gears](https://duelmasters.fandom.com/wiki/Cross_Gear), and [castles](https://duelmasters.fandom.com/wiki/Castle) as your mana zone can afford. You can play any card in any order. (You can only have a maximum of 6 creatures in YGOPro.)
9. During your [Attack Step](https://duelmasters.fandom.com/wiki/Attack_Step), you can [attack](https://duelmasters.fandom.com/wiki/Attack) with your creatures in the battle zone by tapping them and declaring what you want to attack. You cannot attack with creatures you just put into the battle zone this turn because they have [summoning sickness](https://duelmasters.fandom.com/wiki/Summoning_Sickness). As many of your creatures as you want can attack each turn as many times as possible. There is no limit to the number of times a creature can attack each turn as long as it is untapped and you can tap it.
10. During your [End Step](https://duelmasters.fandom.com/wiki/End_Step), [resolve](https://duelmasters.fandom.com/wiki/Resolution) any [abilities](https://duelmasters.fandom.com/wiki/Ability) that [trigger](https://duelmasters.fandom.com/wiki/Trigger) "at the end of your turn". Then your turn ends.

**Important:**
1. At least 1 player must have _Duel Masters Rules_ in their deck, otherwise the mod will not function properly.
2. When you host a game and get an error that tells you the number of a particular card is not allowed in your deck, if there are no illegal cards in your deck it is because YGOPro does not allow you to have more than 3 copies of a card with the same [name](https://duelmasters.fandom.com/wiki/Card_Name). Enable `Do not check deck` when creating a game to avoid this error.
3. YGOPro does not allow you to look at a tapped card in your opponent's mana zone that was put there from a [Private Zone](https://duelmasters.fandom.com/wiki/Private_Zone). You will be able to look at it when it untaps, or is put into a [Public Zone](https://duelmasters.fandom.com/wiki/Public_Zone).

## How to win
1. Attack your opponent with a creature that is not [blocked](https://duelmasters.fandom.com/wiki/Block) (or [attack bended](https://duelmasters.fandom.com/wiki/Attack_Bend)) or removed when they have no shields left.
2. When your opponent has no cards left in their deck or they would draw their last card.
3. [Some cards](https://duelmasters.wikia.com/wiki/Template:Alternate_Win_Condition) will enable you to win the game via their [effects](https://duelmasters.wikia.com/wiki/Effect).

## Extra information for scripters
<details>
<summary>Card Type</summary>

- `0x21	Monster+Effect` = Creature
- `0x1021	Monster+Effect+Tuner` = Creature that has [no abilities](https://duelmasters.wikia.com/wiki/Vanilla)
- `0x2000021	Monster+Effect+Special Summon` = [Evolution Creature](https://duelmasters.fandom.com/wiki/Evolution_Creature)
	- `Attribute` = [Civilization](https://duelmasters.fandom.com/wiki/Civilization)
	- `Level` = [Mana Cost](https://duelmasters.fandom.com/wiki/Mana_Cost)
	- `ATK` = `DEF` = [Power](https://duelmasters.fandom.com/wiki/Power)
- `0x3	Monster+Spell` = Spell
	- `Attribute` = Civilization
	- `Level` = Mana Cost
- `0x800	Gemini` = [Multi-civilization](https://duelmasters.fandom.com/wiki/Multicolored) card
</details>
<details>
<summary>Attribute</summary>

- `0x1	EARTH` = [Nature Civilization](https://duelmasters.fandom.com/wiki/Nature_Civilization)
- `0x2	WATER` = [Water Civilization](https://duelmasters.fandom.com/wiki/Water_Civilization)
- `0x4	FIRE` = [Fire Civilization](https://duelmasters.fandom.com/wiki/Fire_Civilization)
- `0x10	LIGHT` = [Light Civilization](https://duelmasters.fandom.com/wiki/Light_Civilization)
- `0x20	DARK` = [Darkness Civilization](https://duelmasters.fandom.com/wiki/Darkness_Civilization)
</details>
<details>
<summary>Location</summary>

- `0x4	Monster Zone` = Battle Zone
- `0x8	Spell & Trap Zone` = Shield Zone
- `0x10	Graveyard` = Mana Zone (untapped cards)
- `0x20	Banished` = Mana Zone (tapped cards) (text color = blue)
- `0x20	Banished` = [Graveyard](https://duelmasters.fandom.com/wiki/Graveyard) (text color = black)
- `0x40	Extra Deck` = Hyperspatial Zone
</details>
<details>
<summary>Phase</summary>

1. `EVENT_PREDRAW` = Start of Turn Step (Untap Step) = Untap all your tapped cards.
2. `PHASE_DRAW` = Draw Step = Draw a card from your deck.
3. `PHASE_STANDBY` = Charge Step = You may put a card from your hand into your mana zone.
4. `PHASE_MAIN1` = Main Step = You may use cards, such as summoning creatures, casting spells, generating and crossing cross gear or fortifying castles by paying the appropriate costs.
5. `PHASE_BATTLE` = Attack Step = You may attack with creatures or use [Tap Abilities](https://duelmasters.fandom.com/wiki/Tap_Ability).
6. `PHASE_END` = End Step = Any abilities that trigger at "the end of the turn" resolve now.
</details>
<details>
<summary>OT</summary>

- `0x1` = [OCG](https://duelmasters.fandom.com/wiki/OCG) only card
- `0x2` = [TCG](https://duelmasters.fandom.com/wiki/TCG) only card
- `0x3` = OCG + TCG card
- `0x4` = [Game Original](https://duelmasters.fandom.com/wiki/Game_Original_Card)/Custom card
</details>
<details>
<summary>Category</summary>

- `0x1	Destroy Spell/Trap` = Decrease the number of cards in the opponent's shield zone; "Breaker"
- `0x2	Destroy Monster` = Destroy a creature
- `0x4	Banish Card` = Put a card into the graveyard; discard a card from a player's hand
- `0x8	Send to Graveyard` = Put a card into the mana zone
- `0x10	Return to Hand` = Return a card from the battle zone, shield zone, mana zone or graveyard to a player's hand
- `0x20	Return to Deck` = Put a card into a player's deck
- `0x40	Destroy Hand` = Decrease the opponent's hand size
- `0x80	Destroy Deck` = Decrease the opponent's deck size
- `0x100	Increase Draw` = Draw a card from the deck
- `0x200	Search Deck` = Look at a player's deck
- `0x400	GY to Hand/Field` = ～Reserved～
- `0x800	Change Battle Position` = Untap or tap a card
- `0x1000	Get Control` = Increase or decrease the cost required for playing a card
- `0x2000	Increase/Decrease ATK/DEF` = Increase or decrease a creature's power
- `0x4000	Piercing` = No summoning sickness
- `0x8000	Attack Multiple Times` = Can attack untapped creatures
- `0x10000	Limit Attack` = Prevent a creature from attacking; change a creature's attack target
- `0x20000	Direct Attack` = Attacks each turn if able; force a creature to battle another creature
- `0x40000	Special Summon` = Creature with "Shield trigger"; put a card into the battle zone
- `0x80000	Token` = ～Reserved～
- `0x100000	Type-related` = Lists "race" or a particular race in the card's text
- `0x200000	Attribute-related` = Lists "civilization" or a particular civilization in the card's text
- `0x400000	Reduce LP` = Decrease the number of cards in the opponent's mana zone
- `0x800000	Increase LP` = Increase the number of cards in the shield zone
- `0x1000000	Cannot Be Destroyed` = Prevent a card from being destroyed
- `0x2000000	Cannot Be Targeted` = Prevent a creature from being blocked or chosen with an ability
- `0x4000000	Counter` = Prevent the opponent from casting spells
- `0x8000000	Gamble` = ～Reserved～
- `0x10000000	Fusion` = ～Reserved～
- `0x20000000	Synchro` = ～Reserved～
- `0x40000000	Xyz` = Evolution creature; lists "evolution" in the card's text; [evolution source](https://duelmasters.fandom.com/wiki/Evolution_Source)-related
- `0x80000000	Negate Effect` = ～Reserved～
- [Category list](https://duelmasters.fandom.com/wiki/Category:Advanced_Gameplay)
</details>
<details>
<summary>Card Search</summary>

You can search for the following specific card information in YGOPro:
- Card Ability: Use the `No Ability` (`No Ab`) tab for creatures that have no abilities
- Card Type: Use the `Card Type` (`Type`) tab
- Civilization: Use the `Civilization` (`Civ`) tab
- Evolution Creature: Use the `Evolution` (`Evo`) tab
- Mana Cost: Use the `Cost` tab
- Multicolored: Use the `Multicolored` (`Multi`) tab
- Power: Use the `Power` tab
- Race: **N/A**
- Region-exclusive cards: Use the `Limitation` (`Limit`) tab
- You can also search for cards whose abilities have been modified for YGOPro by typing `YGOPro`.
</details>
<details>
<summary>Glossary</summary>

- Ability = `Effect`
- Active Player = `Turn Player`
- Attack Step = `Battle Phase`
- Attack Trigger = `An effect that activates when a monster attacks`
- Break = `Destroy a card in the Spell & Trap Zone`
- Cast = `Activate this Spell's effect in your hand, by banishing cards from your Graveyard face-down equal to its Level, including at least 1 card with the same Attribute as it`
- Category Name ("Archetype") = [`Category`](https://www.db.yugioh-card.com/yugiohdb/deck_search.action?request_locale=en)
- Charge Mana = `Once per turn, during your Standby Phase, send 1 card from your hand to the Graveyard`
- Charge Step = `Standby Phase`
- Choose = `Target` (Japanese text contains 選 or 選ぶ)
- Civilization = `Attribute`
- Come Into Play = `If this card is Special Summoned:`
- Creature = `Monster`
- Defending Player = `Non-Turn Player`
- Discard = `Banish a card from a player's hand. (This is treated as discarding a card.)`
- Draw Step = `Draw Phase`
- End Step = `End Phase`
- Leave = `When a monster leaves the field`
- Look = `Look at a face-down card or a card that is not public knowledge`
- Main Step = `Main Phase 1`
- Mana = `Card in the Graveyard or a face-down banished card`
- Monocolored = `Card with a single Attribute`
- Multicolored = `Card with, or is treated as having, 2 or more Attributes`
- Power = `ATK` = `DEF`
- Put Into Graveyard = `If this card is banished:`
- Race (Category) = `Category` (similar to [Types](https://yugioh.wikia.com/wiki/Type) in Yugioh)
- Reveal = `Show a card`
- Search = `Look at a player's Deck`
- Shield = `Card in the Spell & Trap Zone`
- Static Ability = [`Continuous Effect`](https://yugioh.wikia.com/wiki/Continuous_Effect)
- Step = `Phase`
- Summon = `Special Summon this card (from your hand) in Attack Position, by banishing cards from your Graveyard face-down equal to its Level, including at least 1 card with the same Attribute as it`
- Summoning Sickness = `This card cannot attack the turn it is Special Summoned`
- Switch = `Switch the location of a card in the X Zone with a card in the Y Zone`
- Tap = `Change a monster to Defense Position/Banish a card from the Graveyard face-down`
- Tapped = `Defense Position/Face-down banished card`
- Trigger Ability = [`Trigger Effect`](https://yugioh.wikia.com/wiki/Trigger_Effect)
- Untap = `Change a monster to Attack Position/Send a face-down banished card to the Graveyard`
- Untap Step = `Before the turn player's normal draw`
- Untapped = `Attack Position/Card in the Graveyard`
- Up to = `0 to N` (For example, if a card tells you to "draw up to 3 cards", you can draw 0,1,2, or 3 cards.)
</details>

## Copyright
Duel Masters Official Card Game<br>
©2002 Shogakukan, Mitsui & Co., Ltd

Duel Masters Trading Card Game<br>
©2004 Wizards of the Coast
