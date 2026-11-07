--[[
	constant_dmtcg.lua

	Package path: script/dm/constants.lua

	Loaded once per duel by dm/utility.lua through Duel.LoadScript.
]]

if MDPro4DMConstants then return MDPro4DMConstants end
local DMTCG={}

--Card ID
---Support
CARD_OBSIDIAN_SCARAB				=24005005	--"Obsidian Scarab" (DM-05 5/55)
CARD_AMBUSH_SCORPION				=24005046	--"Ambush Scorpion" (DM-05 46/55)
CARD_SOLAR_GRASS					=24008014	--"Solar Grass" (DM-08 14/55)
CARD_KALUTE_VIZIER_OF_ETERNITY		=24009010	--"Kalute, Vizier of Eternity" (DM-09 10/55)
CARD_WHISPERING_TOTEM				=24009055	--"Whispering Totem" (DM-09 55/55)
CARD_CLONED_DEFLECTOR				=24012022	--"Cloned Deflector" (DM-12 22/55)
CARD_CLONED_SPIRAL					=24012023	--"Cloned Spiral" (DM-12 23/55)
CARD_CLONED_NIGHTMARE				=24012026	--"Cloned Nightmare" (DM-12 26/55)
CARD_CLONED_BLADE					=24012028	--"Cloned Blade" (DM-12 28/55)
CARD_CLONED_SPIKEHORN				=24012030	--"Cloned Spike-Horn" (DM-12 30/55)
---EVENT_CUSTOM
CARD_HOLY_AWE						=24001006	--EVENT_CUSTOM+DM_EVENT_TRIGGER_SHIELD_TRIGGER
CARD_BLOODY_SQUITO					=24001046	--EVENT_CUSTOM+DM_EVENT_WIN_BATTLE
CARD_CREEPING_PLAGUE				=24001049	--EVENT_CUSTOM+DM_EVENT_BECOME_BLOCKED
CARD_MARROW_OOZE_THE_TWISTER		=24002032	--EVENT_CUSTOM+DM_EVENT_ATTACK_PLAYER
CARD_BRUTAL_CHARGE					=24005049	--EVENT_CUSTOM+DM_EVENT_BREAK_SHIELD
CARD_KACHUA_KEEPER					=24008005	--EVENT_CUSTOM+DM_EVENT_EVOLUTION_TO_BZONE
CARD_STORM_WRANGLER_THE_FURIOUS		=24009051	--EVENT_CUSTOM+DM_EVENT_TRIGGER_BLOCKER
CARD_BLUUM_ERKIS_FLARE_GUARDIAN		=24010119	--EVENT_CUSTOM+DM_EVENT_CAST_FREE
CARD_WARPED_LUNATRON				=24011023	--EVENT_CUSTOM+DM_EVENT_UNTAP_START_STEP
CARD_SOUL_PHOENIX					=24012005	--RESERVED --EVENT_CUSTOM+DM_EVENT_TO_SZONE
CARD_GASHI_GASHI					=24013034	--EVENT_CUSTOM+DM_EVENT_LOSE_BATTLE
CARD_WOLFIS_BLUE_DIVINE_DRAGON		=24027		--EVENT_CUSTOM+DM_EVENT_BECOME_SHIELD_TRIGGER
---RegisterFlagEffect
CARD_DIA_NORK_MOONLIGHT_GUARDIAN	=24001002	--DM_EFFECT_BLOCKED
CARD_MIRACLE_QUEST					=24005019	--DM_EFFECT_BREAK_SHIELD
--Win Reason
DM_WIN_REASON_INVALID				=0x4d		--"Invalid deck."
DM_WIN_REASON_DECKOUT				=0x4e		--"Ran out of cards in deck."
DM_WIN_REASON_BOMBAZAR				=0x4f		--"Won due to the ability of [Bombazar, Dragon of Destiny]."
--Setname
---Race (Card.DMIsRace)
DM_RACE_LIGHT_BRINGER				=0x1		--"Chilias, the Oracle" (DM-01 1/110)
DM_RACE_GUARDIAN					=0x2		--"Dia Nork, Moonlight Guardian" (DM-01 2/110)
DM_RACE_STARLIGHT_TREE				=0x3		--"Emerald Grass" (DM-01 3/110)
DM_RACE_INITIATE					=0x4		--"Frei, Vizier of Air" (DM-01 4/110)
DM_RACE_BERSERKER					=0x5		--"Lah, Purification Enforcer" (DM-01 10/110)
DM_RACE_LIQUID_PEOPLE				=0x6		--"Aqua Hulcus" (DM-01 23/110)
DM_RACE_LIQUID_PEOPLE_SEN				=0x1006	--"Bat Mask, Aqua Warrior" (DMR-12 39/55)
DM_RACE_CYBER						=0x7		--"Virus", "Lord", "Cluster" and "Moon"
DM_RACE_CYBER_VIRUS						=0x1007	--"Candy Drop" (DM-01 28/110)
DM_RACE_CYBER_LORD						=0x2007	--"Tropico" (DM-01 42/110)
DM_RACE_CYBER_CLUSTER					=0x4007	--"Angler Cluster" (DM-03 12/55)
DM_RACE_CYBER_MOON						=0x8007	--"Ardent Lunatron" (DM-10 29/110)
DM_RACE_FISH						=0x8		--"Hunter Fish" (DM-01 31/110)
DM_RACE_GEL_FISH						=0x1008	--"Illusionary Merfolk" (DM-01 32/110)
DM_RACE_LEVIATHAN					=0x9		--"King Coral" (DM-01 33/110)
DM_RACE_GHOST						=0xa		--"Black Feather, Shadow of Rage" (DM-01 45/110)
DM_RACE_BRAIN_JACKER				=0xb		--"Bloody Squito" (DM-01 46/110)
DM_RACE_LIVING_DEAD					=0xc		--"Bone Assassin, the Ripper" (DM-01 47/110)
DM_RACE_CHIMERA						=0xd		--"Gigaberos" (DM-01 55/110)
DM_RACE_PARASITE_WORM				=0xe		--"Stinger Worm" (DM-01 61/110)
DM_RACE_DARK_LORD					=0xf		--"Vampire Silphy" (DM-01 64/110)
DM_RACE_ARMORLOID					=0x10		--"Armored Walker Urherion" (DM-01 67/110)
DM_RACE_MACHINE_EATER				=0x11		--"Artisan Picora" (DM-01 68/110)
DM_RACE_DRAGON						=0x12		--"Bolshack Dragon" (DM-01 69/110)
DM_RACE_ARMORED_DRAGON					=0x1012	--"Bolshack Dragon" (DM-01 69/110)
DM_RACE_VOLCANO_DRAGON					=0x2012	--"Magmadragon Jagalzor" (DM-08 4/55)
DM_RACE_ZOMBIE_DRAGON					=0x4012	--"Necrodragon Galbazeek" (DM-08 32/55)
DM_RACE_EARTH_DRAGON					=0x8012	--"Terradragon Gamiratar" (DM-08 54/55)
DM_RACE_HUMAN						=0x13		--"Brawler Zyler" (DM-01 70/110)
DM_RACE_HUMAN_BAKU						=0x1013	--"Glenmalt, Explosive Swordsman" (DMR-12 14/55)
DM_RACE_HUMAN_JYA						=0x2013	--"Seriously Invincible Grandpa" (P56/Y14)
DM_RACE_DRAGO_NOID					=0x14		--"Deadly Fighter Braid Claw" (DM-01 74/110)
DM_RACE_ARMORED_WYVERN				=0x15		--"Draglide" (DM-01 75/110)
DM_RACE_ROCK_BEAST					=0x16		--"Meteosaur" (DM-01 82/110)
DM_RACE_BEAST_FOLK					=0x17		--"Bronze-Arm Tribe" (DM-01 90/110)
DM_RACE_BEAST_FOLK_GO					=0x1017	--"Sasoris, Dragon Edge" (DMR-13 36/110)
DM_RACE_TREE_FOLK					=0x18		--"Coiling Vines" (DM-01 92/110)
DM_RACE_COLONY_BEETLE				=0x19		--"Dome Shell" (DM-01 94/110)
DM_RACE_GIANT						=0x1a		--"Forest Hornet" (DM-01 96/110), "Dawn Giant" (DM-03 46/55)
DM_RACE_GIANT_INSECT					=0x101a	--"Forest Hornet" (DM-01 96/110)
DM_RACE_BALLOON_MUSHROOM			=0x1b		--"Poisonous Mushroom" (DM-01 102/110)
DM_RACE_HORNED_BEAST				=0x1c		--"Stampeding Longhorn" (DM-01 104/110)
DM_RACE_COMMAND						=0x1d		--"Angel", "Demon", "Gaia", "Flame", "World" and "Soul"
DM_RACE_ANGEL_COMMAND					=0x101d	--"Hanusa, Radiance Elemental" (DM-01 S1/S10)
DM_RACE_DEMON_COMMAND					=0x201d	--"Deathliger, Lion of Chaos" (DM-01 S5/S10)
DM_RACE_GAIA_COMMAND					=0x401d	--"Auravine, Earth's Grasp" (DM-32 S10/S10)
DM_RACE_FLAME_COMMAND					=0x801d	--"Tornado Shiva Double Cross, Blastdragon" (DM-36 8/110)
DM_RACE_MECHA_THUNDER				=0x1e		--"Ra Vu, Seeker of Lightning" (DM-03 6/55)
DM_RACE_HEDRIAN						=0x1f		--"Mudman" (DM-03 30/55)
DM_RACE_FIRE_BIRD					=0x20		--"Baby Zoppe" (DM-03 35/55)
DM_RACE_FIRE_BIRD_EN					=0x1020	--"Jet Polka" (DMR-16極 29/54)
DM_RACE_SURVIVOR					=0x21		--"Bladerush Skyterror Q" (DM-05 4/55)
DM_RACE_SEA_HACKER					=0x22		--"Aeropica" (DM-06 3/110)
DM_RACE_RAINBOW_PHANTOM				=0x23		--"Cosmogold, Spectral Knight" (DM-06 17/110)
DM_RACE_GLADIATOR					=0x24		--"Telitol, the Explorer" (DM-06 28/110)
DM_RACE_EARTH_EATER					=0x25		--"Hazard Crawler" (DM-06 34/110)
DM_RACE_DEVIL_MASK					=0x26		--"Grinning Axe, the Monstrosity" (DM-06 60/110)
DM_RACE_DEATH_PUPPET				=0x27		--"Junkatz, Rabid Doll" (DM-06 62/110)
DM_RACE_DUNE_GECKO					=0x28		--"Badlands Lizard" (DM-06 74/110)
DM_RACE_XENOPARTS					=0x29		--"Picora's Wrench" (DM-06 84/110)
DM_RACE_MYSTERY_TOTEM				=0x2a		--"Bliss Totem, Avatar of Luck" (DM-06 91/110)
DM_RACE_SNOW_FAERIE					=0x2b		--"Charmilia, the Enticer" (DM-06 94/110)
DM_RACE_SNOW_FAERIE_KAZE				=0x102b	--"Bell the Elemental" (DMR-16極 16/54)
DM_RACE_MECHA_DEL_SOL				=0x2c		--"Misha, Channeler of Suns" (DM-08 10/55)
DM_RACE_SOLTROOPER					=0x2d		--"Bulgluf, the Spydroid" (DM-10 12/110)
DM_RACE_MERFOLK						=0x2e		--"Mystic Magician" (DM-10 36/110)
DM_RACE_PANDORAS_BOX				=0x2f		--"Benzo, the Hidden Fury" (DM-10 45/110)
DM_RACE_MELT_WARRIOR				=0x30		--"Burnwisp Lizard" (DM-10 64/110)
DM_RACE_WILD_VEGGIES				=0x31		--"Hustle Berry" (DM-10 84/110)
DM_RACE_SPIRIT_QUARTZ				=0x32		--"Deklowaz, the Terminator" (DM-10 S10/S10)
DM_RACE_PHOENIX						=0x33		--"Soul Phoenix, Avatar of Unity" (DM-12 5/55)
DM_RACE_STARNOID					=0x34		--"Wise Starnoid, Avatar of Hope" (DM-12 S2/S5)
DM_RACE_NAGA						=0x35		--"Cruel Naga, Avatar of Fate" (DM-12 S3/S5)
DM_RACE_PEGASUS						=0x36		--"Aura Pegasus, Avatar of Life" (DM-12 S5/S5)
---OCG-only Race (Card.DMIsRace)
----June 25, 2005 (DM-14)
DM_RACE_COSMO_WALKER				=0x37		--"Cabalt, the Patroller" (DM-14 13/110)
DM_RACE_BIG_MUSCLE					=0x38		--"Dynamite Peak" (DM-14 31/110)
DM_RACE_WONDER_TRICK				=0x39		--"Innocent, the Invoked" (DM-14 37/110)
DM_RACE_SPLASH_QUEEN				=0x3a		--"Rosa Rossa" (DM-14 81/110)
DM_RACE_GARGOYLE					=0x3b		--"Telescope Horn" (DM-14 88/110)
DM_RACE_FEATHERNOID					=0x3c		--"Pyuzero, Prince of the South Wind" (DM-14 99/110)
----June 24, 2006 (DM-19)
DM_RACE_ARC_SERAPHIM				=0x3d		--"Arac Kai Bades, Spirit Knight" (DM-19 2/110)
DM_RACE_GRAND_DEVIL					=0x3e		--"Fuuma Soul Avals" (DM-19 5/110)
DM_RACE_TYRANNO_DRAKE				=0x3f		--"Ribengios Dragoon" (DM-19 6/110)
DM_RACE_DREAMMATE					=0x40		--"Red Jackal, Raider of the North Sea" (DM-19 8/110)
DM_RACE_GREAT_MECHA_KING			=0x41		--"Steel-Armor Benkeroth" (DM-19 12/110)
DM_RACE_DYNAMO						=0x42		--"Steel-Armor Benkeroth" (DM-19 12/110)
DM_RACE_DEEP_MARINE					=0x43		--"Snipe Alpheras" (DM-19 57/110)
DM_RACE_BRAVE_SPIRIT				=0x44		--"Sag Panel of Eradication" (DM-19 91/110)
DM_RACE_VEHICLE_BEE					=0x45		--"General Kuwagatan" (DM-19 S9/S10)
----Aug. 21, 2006 (DM-20)
DM_RACE_HERO						=0x46		--"Yuu, Passionate Duel Hero" (DMX-06 21/21)
DM_RACE_MACHINE_HERO					=0x1046	--"Captain Gyro" (DM-20 22/55)
DM_RACE_SAINT_HEAD					=0x47		--"Manitus, Protection Spirit" (DM-20 53/55)
---Dec. 27, 2006 (DM-22)
DM_RACE_APOLLONIA_DRAGON				=0x48	--(DM_RACE_DRAGON) "Spell Del Fin, Light Divine Dragon" (DM-22 1/55)
DM_RACE_POSEIDIA_DRAGON					=0x49	--(DM_RACE_DRAGON) "Spell Great Blue, Blue Divine Dragon" (DM-22 2/55)
----June 23, 2007 (DM-24)
DM_RACE_GOD							=0x4a		--"God Apollonia Pegasus" (DM-24 1/110)
DM_RACE_GOD_NOVA						=0x104a	--"Daft Punk, Lord of Demons Right God" (DMR-09 1/110)
DM_RACE_GOD_NOVA_OMG					=0x304a	--"Electraglide, Fallen Left God" (DMR-11 3/55)
DM_RACE_LOST_CRUSADER				=0x4b		--"Glen Bramsley, Red Destroyer of Gaia" (DM-24 9/110)
----Mar. 20, 2008 (DM-27)
DM_RACE_WORLD_BIRD					=0x4c		--"Miracle Rumba" (DM-27 S4/S5)
DM_RACE_WORLD_DRAGON					=0x4d	--(DM_RACE_DRAGON) "Perfect Earth, Planetary Dragon" (DM-27 S5/S5)
----June 21, 2008 (DM-28)
DM_RACE_MONSTER						=0x4e		--"Million Death, Lord of a Hundred Beasts" (DM-39 3/55)
DM_RACE_BLUE_MONSTER					=0x104e	--"Deepsea Searcher" (DM-28 3/55)
DM_RACE_FLAME_MONSTER					=0x204e	--"Max, Crimson Blade Lord" (DM-28 7/110)
DM_RACE_SHINE_MONSTER					=0x404e	--"Pure Unicorn" (DM-28 12/110)
DM_RACE_DARK_MONSTER					=0x804e	--"Darkness Limit" (DM-28 25/110)
DM_RACE_KNIGHT						=0x4f		--"King Maximillian, the Ice Fang" (DM-28 4/55)
DM_RACE_FUNKY_KNIGHTMARE				=0x104f	--"Uroborof, Dragon Edge" (DMR-13 25/110)
DM_RACE_DARK_KNIGHTMARE					=0x204f	--"Vicious Deslar, Dream Knight" (DMR-16極 2/54)
DM_RACE_SAMURAI						=0x50		--"Dragon Gear - Musha Legend" (DM-28 8/110)
DM_RACE_EMERALD_MONSTER					=0x51	--(DM_RACE_MONSTER) "Paol Nature" (DM-28 37/110)
----Sept. 6, 2008 (DM-29)
DM_RACE_SHINOBI						=0x52		--"Orochi of the Hidden Blade" (DM-29 2/55)
----Mar. 20, 2009 (DM-31)
DM_RACE_ORIGIN						=0x53		--"Amaterasu, Founder of the Blue Wolves" (DM-31 10/55)
----June 27, 2009 (DM-32)
DM_RACE_LUNATIC_EMPEROR				=0x54		--"Spiral Moon, the Enlightened" (DM-32 47/110)
----Nov. 21, 2009 (DMC-57)
DM_RACE_CREATOR						=0x55		--"Saga, the Almighty Creator" (DMC-57 6/39)
----Mar. 20, 2010 (DM-35)
DM_RACE_LUNAS_SUN_GEYSER			=0x56		--"Galaxy Operation Theta, the Super Enlightened" (DM-35 2/55)
----Mar. 19, 2011 (DM-39)
DM_RACE_SOUL_COMMAND					=0x57	--(DM_RACE_COMMAND) "Final Doppel" (DM-39 5/55)
DM_RACE_ALIEN						=0x58		--"V-Y, the Patroller" (DM-39 6/55)
DM_RACE_WORLD_COMMAND					=0x59	--(DM_RACE_COMMAND) "Diabolos Zeta, Temporal Ruler" (DM-39 S5a/S5)
----May 21, 2011 (DMX-01)
DM_RACE_RED_COMMAND_DRAGON				=0x5a	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "Raging Dragon Lord" (DMX-01 9/40)
DM_RACE_HUNTER						=0x5b		--"Raging Dragon Lord" (DMX-01 9/40)
DM_RACE_RAINBOW_COMMAND_DRAGON			=0x5c	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "Dead Sea Dragon" (DMX-01 15/40)
----June 25, 2011 (DMR-01)
DM_RACE_EGG							=0x5d		--"Dragon Flare Egg" (DMR-01 32/110)
DM_RACE_DEVIL_COMMAND_DRAGON			=0x5e	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "Gallows Devil Dragon, Dead Sea Dragon" (DMR-01 53b/110+59b/110)
DM_RACE_KING_COMMAND_DRAGON				=0x5f	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "Gaial King Dragon, Raging Dragon Lord" (DMR-01 60b/110+62b/110)
----Sept. 23, 2011 (DMR-02)
DM_RACE_BLUE_COMMAND_DRAGON				=0x60	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "Insight Indigo Kaiser" (DMR-02 1/54)
----Oct. 22, 2011 (DMX-04 & DMX-05)
DM_RACE_BLACK_COMMAND_DRAGON			=0x61	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "THE FINAL Kaiser" (DMX-04 1/16)
DM_RACE_SHINING_COMMAND_DRAGON			=0x62	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "Crazy Carnival! Saint Chan-Merrie" (DMX-04 4b/16)
DM_RACE_WHITE_COMMAND_DRAGON			=0x63	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "White TENMTH Kaiser" (DMX-05 1a/16)
----Dec. 17, 2011 (DMR-03)
DM_RACE_UNKNOWN						=0x64		--"Codename Sorge" (DMR-03 S5/S5)
----Feb. 10, 2012 (DMX-06)
DM_RACE_SUMO_WRESTLER_COMMAND			=0x65	--(DM_RACE_COMMAND) "Nibai Nibai, Mysterious Fire Yokozuna" (DMX-06 2/21)
DM_RACE_BEAST_COMMAND					=0x66	--(DM_RACE_COMMAND) "Jin, the Ogre Blade ~Crimson Rage~" (DMX-06 V1a/V1)
----Mar. 24, 2012 (DMR-04)
DM_RACE_GAO_MONSTER						=0x67	--(DM_RACE_MONSTER) "Deis Orthrus, Brave Beast King" (DMR-04 15/55)
----Mar. 24, 2012 (The Complete Cards File Ultra E1 - Wonder Life Special) 
DM_RACE_CURRY_BREAD					=0x68		--"Katta Kirifuda, Curry Bread Boy" (P23/Y11)
----Apr. 21, 2012 (DMD-06)
DM_RACE_UNNOISE						=0x69		--"Kachamashigu, Spirit of Rays" (DMD-06 2/14)
----June 23, 2012 (DMR-05)
DM_RACE_ZENITH						=0x6a		--"Lionel, Zenith of "Ore"" (DMR-05 V1/V3)
----Oct. 15, 2012 (CoroCoro Comic November 2012 Issue)
DM_RACE_IDOL						=0x6b		--"Idolmaster Leo" (P58/Y11)
DM_RACE_WORLD_IDOL						=0x106b	--"Ultimate Man" (DMX-22 115/???)
----Nov. 15, 2012 (CoroCoro Comic December 2012 Issue)
DM_RACE_PIANIST						=0x6c		--"VAN Beat, Battlefield Pianist" (P67/Y11)
----Nov. 17, 2012 (DMD-07)
DM_RACE_GREEN_COMMAND_DRAGON			=0x6d	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "Danchino Kaiser, Mother Green Oni Dragon" (DMD-07 5/24)
----Dec. 15, 2012 (DMR-07)
DM_RACE_TRISTONE					=0x6e		--"Niyare" (DMR-07 33/55)
----Jan. 26, 2013 (DMX-12)
DM_RACE_SPECIAL_CLIMAX				=0x6f		--"Great Waste" (DMX-12 b21/???)
----Feb. 23, 2013 (DMX-13)
DM_RACE_ORACLE						=0x70		--"Saicho, Satori's Oracle" (DMX-13 12/36)
DM_RACE_OUTRAGE						=0x71		--"Smith, Breaking Right" (DMX-13 26/36)
DM_RACE_OUTRAGE_OMG						=0x1071	--"Katsumugen, Climax" (DMR-12 V2/V2)
DM_RACE_OUTRAGE_NYANKO					=0x2071	--"Nyannyan, Nyanko Rage" (DMX-22 b22/???)
DM_RACE_OUTRAGE_WANKO					=0x4071	--"Wanwanwan, Wankorage" (DMX-22 b110/???)
DM_RACE_OUTRAGE_MAX						=0x8071	--"Ragnarok, the Clock" (P18/Y12)
----Mar. 30, 2013 (DMR-08S)
DM_RACE_CHILDREN					=0x72		--"Violent Children" (DMR-08S 4/7)
----Apr. 20, 2013 (DMD-10)
DM_RACE_ORACLION					=0x73		--"Alternative, Sacred Cavalry" (DMD-10 1/14)
----Aug. 2013 (Weekly Shonen Sunday 2013 No. 8)
DM_RACE_MAGICAL_MONSTER					=0x74	--(DM_RACE_MONSTER) "Karre Ganejar, Metal Lamp Djinn" (P65/Y11)
----Feb. 22, 2014 (DMR-12)
DM_RACE_JUSTICE_WING				=0x75		--"Kigunashion, Pure White Wings" (DMR-12 21/55)
----Mar. 21, 2014 (DMD-17)
DM_RACE_CRYSTAL_COMMAND_DRAGON			=0x76	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "iQ Cloypaedia, Dragment Symbol" (DMD-17 1/14)
----Apr. 19, 2014 (DMX-16)
DM_RACE_JURASSIC_COMMAND_DRAGON			=0x77	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "Triprex, Growth King" (DMX-16 36/84)
----May 24, 2014 (DMR-13)
DM_RACE_GAIAL_COMMAND_DRAGON			=0x78	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "Gaigensui, Striking Hero" (DMR-13 7/110)
DM_RACE_DRAGUNER					=0x79		--"Everrose, Dragon Edge" (DMR-13 13/110)
----Feb. 21, 2015 (DMR-16極)
DM_RACE_MEGA_COMMAND_DRAGON				=0x7a	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "Gou Break Dragon" (DMR-16極 3/54)
DM_RACE_CYBER_VIRUS_KAI					=0x7b	--(DM_RACE_CYBER_VIRUS) "Octopuscal, Great Captain" (DMR-16極 21/54)
----Mar. 21, 2015 (DMR-16真)
DM_RACE_JUSTICE_ORB					=0x7c		--"Ribulibarrier, Holy Ball" (DMR-16真 5/54)
----June 20, 2015 (DMR-17)
DM_RACE_INVADER						=0x7d		--"Bhuddi, Three Kingdoms" (DMR-17 1/94)
DM_RACE_S_RANK_INVADER					=0x107d	--"Dead Dollar, S-Rank Zombie" (DMR-19 17/87)
DM_RACE_INVADER_ZERO					=0x207d	--"The ZERO, Black Speed" (DMR-22 54/74)
DM_RACE_REVOLUTIONARY				=0x7e		--"Cylinder, Revolution Dragon Formula" (DMR-17 3/94)
DM_RACE_MASTER_REVOLUTIONARY			=0x107e	--"Wachagona, Muen Zangu" (DMR-22 S5/S9)
DM_RACE_MAGIC_COMMAND					=0x7f	--(DM_RACE_COMMAND) "Pocard, Eureka" (DMR-17 4/94)
DM_RACE_GUERRILLA_COMMAND				=0x80	--(DM_RACE_COMMAND) "Runbomber, Beast Army" (DMR-17 26/94)
DM_RACE_SONIC_COMMAND					=0x81	--(DM_RACE_COMMAND) "Burunburu, Invader" (DMR-17 48/94)
DM_RACE_FORBIDDEN_SONIC_COMMAND			=0x1081	--(DM_RACE_COMMAND) "Dokindam Black" (DMD-35 2/12)
----Dec. 18, 2015 (DMR-19)
DM_RACE_INITIALS					=0x82		--"Trooper, Forbidden U" (DMR-19 43/87)
DM_RACE_INITIALS_X						=0x1082	--"Dorhakaba, Final Forbidden Delta" (DMR-23 43/74)
DM_RACE_MASTER_INITIALS					=0x2082	--"Forbidden Voltron, D2-V" (DMD-31 1/12)
----Jan. 30, 2016 (DMX-22)
DM_RACE_2016_CALENDAR				=0x83		--"January" (DMX-22 b1/???)
DM_RACE_NARRATOR					=0x84		--"Narrataro, Explosive Passion" (DMX-22 b33/???)
DM_RACE_METAL_COMMAND_DRAGON			=0x85	--(DM_RACE_DRAGON,DM_RACE_COMMAND) "Kushala Daora, Steel Dragon" (DMX-22 b109/???)
DM_RACE_ELDER_DRAGON					=0x86	--(DM_RACE_DRAGON) "Nicol Bolas" (DMX-22 b128/???)
DM_RACE_PLANESWALKER				=0x87		--"Nicol Bolas" (DMX-22 b128/???)
DM_RACE_SPECIAL_THANKS				=0x88		--"Great Thanks" (DMX-22 b160/???)
----Mar. 19, 2016 (DMR-20)
DM_RACE_THE_ANSWER					=0x89		--"Duerou, Weapon of Dreams" (DMR-20 29/70)
DM_RACE_QQQ								=0x1089	--??? -- "Unidentified" (DMR-18 S3/S9)
----Apr. 23, 2016 (DMD-29 & DMD-30)
DM_RACE_TEAM_HAMUKATSU				=0x8a		--"Briking, Deluxe" (DMD-29 1/13)
DM_RACE_TEAM_DOREMI					=0x8b		--"Belufare, Great Cathedral" (DMD-30 1/13)
DM_RACE_ANGEL_DRAGON					=0x8c	--(DM_RACE_DRAGON) "Kernel, Blue Stagnation Dragon Elemental" (DMD-30 3/13)
----May 28, 2016 (DMR-21)
DM_RACE_JURASSIC_DRAGON					=0x8d	--(DM_RACE_DRAGON) "Amurex, Rainbowkind" (DMR-21 8/94)
DM_RACE_TEAM_DAMAMA					=0x8e		--"Wekapipo, Tatu" (DMR-21 22/94)
DM_RACE_TEAM_TECH					=0x8f		--"Jiin, "Question 3"" (DMR-21 24/94)
DM_RACE_CRYSTAL_DRAGON					=0x90	--(DM_RACE_DRAGON) "Noron, "Question 2"" (DMR-21 52/94)
DM_RACE_DEMON_DRAGON					=0x91	--(DM_RACE_DRAGON) Tamagineil, Second Seed" (DMR-21 54/94)
DM_RACE_TEAM_ACME					=0x92		--"Tamagineil, Second Seed" (DMR-21 54/94)
DM_RACE_MEGA_DRAGON						=0x93	--"Katsuemon, Blade 3" (DMR-21 56/94)
----Sept. 17, 2016 (DMR-22)
DM_RACE_MILKBOY						=0x94		--"BoleBole, Bei B" (DMR-22 38/74)
----Dec. 16, 2016 (DMR-23)
DM_RACE_METALLICA					=0x95		--"Phantasm, Moon's Radiance" (DMR-23 S1/S9)
----Mar. 25, 2017 (DMRP-01)
DM_RACE_JOKERS						=0x96		--"Dotsuking, Three Crown King" (DMRP-01 1/93)
DM_RACE_MUTOPIA						=0x97		--"Octoba, Sublime Knowledge" (DMRP-01 4/93)
DM_RACE_SPECIALS					=0x98		--"Hoseters 5" (DMRP-01 5/93)
DM_RACE_MAFI_GANG					=0x99		--"Stomak, Electric Killer" (DMRP-01 6/93)
DM_RACE_BEAT_JOCKEY					=0x9a		--"Block King" (DMRP-01 8/93)
DM_RACE_GRANSECT					=0x9b		--"Shizenseijin" (DMRP-01 10/93)
DM_RACE_GRANSECT_HAZARD					=0x109b	--"Baraghiara, Violent Heaven" (DMBD-08 a-1/13)
DM_RACE_DRAGON_GUILD					=0x9c	--(DM_RACE_DRAGON) "Borsche, Dragon Car" (DMRP-01 47/93)
----Nov. 11, 2017 (DMBD-04)
DM_RACE_JUDGMENT_EMBLEM				=0x9d		--"One Eye's Judgment" (DMBD-04 8/15)
DM_RACE_JUDGMENT_EMBLEM_Z				=0x109d	--"Kokuchono Seisai Zett" (DMSD-07 5/13)
----Dec. 16, 2017 (DMRP-04裁)
DM_RACE_SABAKIST					=0x9e		--"Tsudoino Sabato" (DMRP-04裁 12/93)
DM_RACE_MASTER_DG					=0x9f		--"Savaak DG" (DMRP-04裁 M1/M1)
----Jan. 2018 (CoroCoro Comic, January 2018 issue)
DM_RACE_MASTER_DRAGON					=0xa0	--(DM_RACE_DRAGON) "Savark ~Judgment for Justice~" (P84/Y16)
----Jan. 27, 2018 (DMRP-04魔)
DM_RACE_MAGIC_TOOL					=0xa1		--"Vogaiga, Darma" (DMRP-04魔 5/61)
DM_RACE_DOLSZAK						=0xa2		--"De Rupansa"  (DMSD-06 1/15)
DM_RACE_MASTER_DOLSZAK					=0x10a2	--"De Szark" (DMRP-04魔 MD1/MD1)
----Oct. 20, 2018 (DMEX-03)
DM_RACE_SPRIGGAN					=0xa3		--"Messer Schmitt" (DMEX-03 G1/G3)
----Mar. 30, 2019 (DMRP-09)
DM_RACE_WONDERFORCE					=0xa4		--"Haileader, Play Music" (DMRP-09 1/102)
DM_RACE_TRICKS						=0xa5		--"Ganime De, Kyokugenchi" (DMRP-09 4/102)
DM_RACE_DELETRON					=0xa6		--"Ganime De, Kyokugenchi" (DMRP-09 4/102)
---Name Category (Card.IsNameCategory)
----Sept. 6, 2008 (DM-29)
DM_NAME_SWORD_FLASH					=0xa00		--"Balrun Shizou" (DM-30 16/55)
DM_NAME_SWORD_FLASH_DRAGON				=0x1a00	--"Borkov Shion" (DM-35 31/55)
DM_NAME_BOLBALZAK_SWORD_FLASH_DRAGON	=0x3a00	--"Bullet "Shirou" Barrett" (DM-29 16/55)
----June 27, 2009 (DM-32)
DM_NAME_KEN_CRIMSON_LORD			=0xa01		--"Wan Ken, Crimson Lord ~Moonlight Howl~" (DM-32 60/110)
DM_NAME_KEN_GOU_CRIMSON_LORD			=0x1a01	--"Wan Ken, Crimson Lord ~Moonlight Howl~" (DM-32 60/110)
DM_NAME_WAN_KEN_CRIMSON_LORD			=0x2a01	--"Ken, Crimson Lord ~Journey's Beginning~" (DM-32 101/110)
DM_NAME_LUPIA						=0xa02		--"Bolshack NEX" (DM-32 S8/S10)
----Sept. 19, 2009 (DM-33)
DM_NAME_LORD_GOU_KEN				=0xa03		--"Ken Gou, Crimson Lord ~The Sundering~" (DM-33 16/55)
DM_NAME_WHITE_KNIGHT				=0xa04		--"Astinos, White Knight Spirit" (DM-33 36/55)
----Dec. 19, 2009 (DM-34)
DM_NAME_KEN_GEKI_ABSOLUTE_RULER_FINAL_FLARE	=0xa05	--"Lord Gou Ken ~Symphony of Swords~" (DM-34 15/55)
DM_NAME_NEX							=0xa06		--"Cutie Lupia" (DM-34 41/55)
DM_NAME_AKU_AND_ZEN					=0xa07		--"Saga, God of Destruction" (DM-34+1S 3S/3S)
----Jan. 30, 2010 (DMC-58)
DM_NAME_ROMANOV						=0xa08		--"Dark Division, Demonic Eye Beast" (DMC-58 5/16)
----June 26, 2010 (DM-36)
DM_NAME_SPARK						=0xa09		--"Sun's Creed, Spirit of Revelation" (DM-36 2/110)
DM_NAME_HYPERSPATIAL				=0xa0a		--"Flame Shiva Double Cross, Blastdragon" (DM-36 60/110)
DM_NAME_DOUBLE_CROSS				=0xa0b		--"Chai Aini" (DM-36 97/110)
DM_NAME_GENJI_DOUBLE_CROSS				=0x1a0b	--"Reppi SP Aini" (DM-39 30/55)
----July 24, 2010 (DMC-63)
DM_NAME_EMPEROR_OF_THE_GODS			=0xa0c		--"Suva, Temporal Menace" (DMC-63 1a/19)
----Sept. 11, 2010 (DM-37)
DM_NAME_ZETA						=0xa0d		--"Darkness Dober" (DM-37 45/55)
----Mar. 19, 2011 (DM-39)
DM_NAME_AWAKENED					=0xa0e		--"Words from Beyond" (DM-39 10/55)
DM_NAME_FIVE_STAR					=0xa0f		--"Tulk SP" (DM-39 21/55)
DM_NAME_REAPER						=0xa10		--"Belbel, Reaper Doll" (DM-39 28/55)
DM_NAME_AINI						=0xa11		--"GENJI Blaster" (DM-39 32/55)
DM_NAME_G_HOGAN						=0xa12		--"Ribbity SP" (DM-39 40/55)
DM_NAME_GANVEET						=0xa13		--"Dark Strike SP" (DM-39 45/55)
DM_NAME_KANKURO						=0xa14		--"Princess Cub SP" (DM-39 53/55)
----July 2, 2011 (Duel Masters: Walkthrough E1)
DM_NAME_BOLSHACK					=0xa15		--"Gaial Bolshack, Raging Dragon" (P21/Y10)
----Sept. 22, 2012 (DMR-06)
DM_NAME_VICTORY						=0xa16		--"Kaiser Flame, Secret Flame Dragon" (DMR-06 30/55)
----Oct. 20, 2012 (DMX-11)
DM_NAME_HEAVENS						=0xa17		--"Kibbate Cat, Heaven's Gate Elemental" (DMX-11 38/84)
----Oct. 26, 2013 (DMX-15)
DM_NAME_PARLOCK						=0xa18		--"Parlock, Sacred Prayer" (DMX-15 1/30)
----Dec. 20, 2013 (DMR-11)
DM_NAME_PRIN						=0xa19		--"Kaiser Prince, Flame Dragon Prince" (DMR-11 5/55) ("Prince", "Princess" and "Springs")
DM_NAME_SHEN						=0xa1a		--"Lance of Tonginus" (DMR-11 7/55)
DM_NAME_TESTA_ROSSA					=0xa1b		--"Testa Rossa, Last Burning" (DMR-11 S5/S5)
----Feb. 22, 2014 (DMR-12)
DM_NAME_RYUSEI						=0xa1c		--"Ryusei, the End of Conclusion" (DMR-12 S5/S5)
----June 21, 2014 (DMD-18)
DM_NAME_GAIAL						=0xa1d		--"Gaial, Leader Dragon Sword" (DMD-18 2a/20)
----Dec. 19, 2014 (DMR-15)
DM_NAME_PARAS						=0xa1e		--"Parasrex, Chain Parasitic Eye" (DMR-15 18/55)
----Feb. 21, 2015 (DMR-16極)
DM_NAME_GUERRILLA_DIVISION			=0xa1f		--"Tsurato Usutora, Leader of Division" (DMR-16極 19/54)
----Aug. 8, 2015 (DMD-24)
DM_NAME_BOLMETEUS					=0xa20		--"Bolmeteus White Flare" (DMD-24 11/37)
----Oct. 24, 2015 (DMX-21)
DM_NAME_MUSHA						=0xa21		--"Dragon Gear - Sengoku Topper Armor" (DMX-21 13/70)
DM_NAME_YAMATO						=0xa22		--"Dragon Gear - Sengoku Topper Armor" (DMX-21 13/70)
DM_NAME_LORD_OF_SPIRITS				=0xa23		--"Alca Kid, Holy Elemental" (DMX-21 33/70)
DM_NAME_BALLOM						=0xa24		--"Barlowe, Devil Priest" (DMX-21 40/70)
DM_NAME_BOLBERG						=0xa25		--"Great Earth" (DMX-21 46/70)
----Dec. 18, 2015 (DMR-19)
DM_NAME_DOKINDAM					=0xa26		--"Marmo, Forbidden C" (DMR-19 74/87)
----Dec. 16, 2016 (DMR-23)
DM_NAME_FORBIDDEN					=0xa27		--"FORBIDDEN STAR ~World's Last Day~" (DMR-23 FFL1a/FFL5)
----Oct. 2017 (CoroCoro Comic, October 2017 issue)
DM_NAME_DG							=0xa28		--"DG ~Time of Judgment~" (P54/Y16)
----Dec. 16, 2017 (DMRP-04裁)
DM_NAME_STORED_MAGIC				=0xa29		--"Pernore, Stored Magic" (DMRP-04裁 37/93)
----Mar. 31, 2018 (DMRP-05 Gokai!! Joragon Go Fight!!)
DM_NAME_MEN							=0xa2a		--"Charmeijin, Hundred Delivery" (DMRP-05 1/93)
----June 23, 2018 (DMRP-06)
DM_NAME_BRAIN						=0xa2b		--"Neonkus, Palace Missionary" (DMRP-06 3/93)
DM_NAME_HAND						=0xa2c		--"Mad Demon Excellency" (DMRP-06 6/93)
DM_NAME_SCRAPPER					=0xa2d		--"Magmajigoku, Dragon Armored Car" (DMRP-06 7/93)
DM_NAME_TRAP						=0xa2e		--"Na Turalgo Danger" (DMRP-06 S9/S10)
--Min/Max Value
MAX_NUMBER							=999999999	--Max number allowed in YGOPro
DM_MAX_MANA_COST					=4294967295	--"Dormageddon X, Forbidden Armageddon" (DMR-23 FFL1,FFL2,FFL3,FFL4,FFL5/FFL5)
--Location
LOCATION_ALL						=0xff		--All locations
DM_LOCATION_BZONE					=LOCATION_MZONE						--Battle Zone
DM_LOCATION_SZONE					=LOCATION_SZONE						--Shield Zone
DM_LOCATION_MZONE					=LOCATION_GRAVE+LOCATION_REMOVED	--Mana Zone
DM_LOCATION_GRAVE					=LOCATION_REMOVED					--Graveyard
--Position
POS_FACEUP_UNTAPPED					=POS_FACEUP_ATTACK		--Face-up untapped
POS_FACEDOWN_UNTAPPED				=POS_FACEDOWN_ATTACK	--N/A
POS_FACEUP_TAPPED					=POS_FACEUP_DEFENSE		--Face-up tapped 
POS_FACEDOWN_TAPPED					=POS_FACEDOWN_DEFENSE	--N/A
POS_UNTAPPED						=POS_ATTACK				--RESERVED --Face-up or face-down untapped
POS_TAPPED							=POS_DEFENSE			--RESERVED --Face-up or face-down untapped
--Type (Card.IsType)
DM_TYPE_CREATURE					=TYPE_EFFECT			--Creature
DM_TYPE_MULTICOLORED				=TYPE_DUAL				--Card that has 2 or more civilizations
DM_TYPE_NO_ABILITY					=TYPE_TUNER				--Creature that has no abilities
DM_TYPE_EVOLUTION					=TYPE_SPSUMMON			--Evolution creature
--Civilization
DM_CIVILIZATION_NONE				=0x0				--No civilization (including Zero and Jokers)
DM_CIVILIZATION_ALL					=ATTRIBUTE_LIGHT+ATTRIBUTE_WATER+ATTRIBUTE_DARK+ATTRIBUTE_FIRE+ATTRIBUTE_EARTH	--Include all 5 civilizations
DM_CIVILIZATION_LIGHT				=ATTRIBUTE_LIGHT	--Light
DM_CIVILIZATION_WATER				=ATTRIBUTE_WATER	--Water
DM_CIVILIZATION_DARKNESS			=ATTRIBUTE_DARK		--Darkness
DM_CIVILIZATION_FIRE				=ATTRIBUTE_FIRE		--Fire
DM_CIVILIZATION_NATURE				=ATTRIBUTE_EARTH	--Nature
DM_CIVILIZATION_COUNT				=5					--Number of different civilizations that exists
---2 color civilization combinations (Multicolored)
DM_CIVILIZATIONS_LW					=DM_CIVILIZATION_LIGHT+DM_CIVILIZATION_WATER		--Light and water
DM_CIVILIZATIONS_LD					=DM_CIVILIZATION_LIGHT+DM_CIVILIZATION_DARKNESS		--Light and darkness
DM_CIVILIZATIONS_WD					=DM_CIVILIZATION_WATER+DM_CIVILIZATION_DARKNESS		--Water and darkness
DM_CIVILIZATIONS_LF					=DM_CIVILIZATION_LIGHT+DM_CIVILIZATION_FIRE			--Light and fire
DM_CIVILIZATIONS_WF					=DM_CIVILIZATION_WATER+DM_CIVILIZATION_FIRE			--Water and fire
DM_CIVILIZATIONS_DF					=DM_CIVILIZATION_DARKNESS+DM_CIVILIZATION_FIRE		--Darkness and fire
DM_CIVILIZATIONS_LN					=DM_CIVILIZATION_LIGHT+DM_CIVILIZATION_NATURE		--Light and nature
DM_CIVILIZATIONS_WN					=DM_CIVILIZATION_WATER+DM_CIVILIZATION_NATURE		--Water and nature
DM_CIVILIZATIONS_DN					=DM_CIVILIZATION_DARKNESS+DM_CIVILIZATION_NATURE	--Darkness and nature
DM_CIVILIZATIONS_FN					=DM_CIVILIZATION_FIRE+DM_CIVILIZATION_NATURE		--Fire and nature
---3 color civilization combinations (Multicolored)
DM_CIVILIZATIONS_DFN				=DM_CIVILIZATIONS_DF+DM_CIVILIZATION_NATURE			--Darkness, fire and nature
DM_CIVILIZATIONS_LFN				=DM_CIVILIZATIONS_LF+DM_CIVILIZATION_NATURE			--Light, fire and nature
DM_CIVILIZATIONS_LWD				=DM_CIVILIZATIONS_LW+DM_CIVILIZATION_DARKNESS		--Light, water and darkness
DM_CIVILIZATIONS_LWN				=DM_CIVILIZATIONS_LW+DM_CIVILIZATION_NATURE			--Light, water and nature
DM_CIVILIZATIONS_WDF				=DM_CIVILIZATIONS_WD+DM_CIVILIZATION_FIRE			--Water, darkness and fire
DM_CIVILIZATIONS_LDF				=DM_CIVILIZATIONS_LD+DM_CIVILIZATION_FIRE			--Light, darkness and fire
DM_CIVILIZATIONS_LDN				=DM_CIVILIZATIONS_LD+DM_CIVILIZATION_NATURE			--Light, darkness and nature
DM_CIVILIZATIONS_LWF				=DM_CIVILIZATIONS_LW+DM_CIVILIZATION_FIRE			--Light, water and fire
DM_CIVILIZATIONS_WDN				=DM_CIVILIZATIONS_WD+DM_CIVILIZATION_NATURE			--Water, darkness and nature
DM_CIVILIZATIONS_WFN				=DM_CIVILIZATIONS_WF+DM_CIVILIZATION_NATURE			--Water, fire and nature
---4 color civilization combinations (Multicolored)
DM_CIVILIZATIONS_LWDF				=DM_CIVILIZATIONS_LW+DM_CIVILIZATIONS_DF			--Light, water, darkness and fire
---5 color civilization combinations (Multicolored)
DM_CIVILIZATIONS_LWDFN				=DM_CIVILIZATIONS_LW+DM_CIVILIZATIONS_DF+DM_CIVILIZATION_NATURE	--Light, water, darkness, fire and nature
--Reason
DM_REASON_BREAK						=0x20000000		--Reason for breaking a player's shield
--Summon Type
DM_SUMMON_TYPE_NORMAL				=0x49000000		--Summon a creature by paying its mana cost(SUMMON_TYPE_XYZ)
DM_SUMMON_TYPE_EVOLUTION			=0x49000100		--Summon a creature by evolving a creature in the battle zone(SUMMON_TYPE_XYZ+0x100)
--Status
DM_STATUS_TO_BZONE_TURN				=STATUS_SPSUMMON_TURN	--Status of a creature that was put into the battle zone during the current turn
--Player (as parameter)
PLAYER_OWNER						=nil	--player=PLAYER_OWNER in Duel.Sendto..(targets, player, reason)
PLAYER_SELF							=0		--player=PLAYER_SELF in Effect.SetCondition(Auxiliary.Function(player)), etc.
PLAYER_OPPO							=1		--player=PLAYER_OPPO in Effect.SetCondition(Auxiliary.Function(player)), etc.
--Reset
---Reset combinations
RESETS_STANDARD						=0x1fe0000	--RESET_TURN_SET+RESET_TOGRAVE+RESET_REMOVE+RESET_TEMP_REMOVE+RESET_TOHAND+RESET_TODECK+RESET_LEAVE+RESET_TOFIELD
RESETS_REDIRECT						=0x47e0000	--RESETS_STANDARD+RESET_OVERLAY-RESET_TOFIELD-RESET_LEAVE (EFFECT_LEAVE_FIELD_REDIRECT)
--Type (for SetType)
DM_EFFECT_TYPE_CAST_SPELL			=EFFECT_TYPE_IGNITION			--Cast a spell
--Flag
DM_EFFECT_FLAG_SUMMON_PARAM			=EFFECT_FLAG_SPSUM_PARAM		--Included in a creature's summon procedure
DM_EFFECT_FLAG_CHAIN_LIMIT			=0x20000000						--Included in an effect that cannot be chained to
DM_EFFECT_FLAG_CHARGE				=0x40000000						--Included in an effect where a player puts the cast spell into the mana zone
--Code
DM_EFFECT_TO_BZONE_CONDITION		=EFFECT_SPSUMMON_CONDITION		--Can only be put into the battle zone if a condition is met
DM_EFFECT_SUMMON_PROC				=EFFECT_SPSUMMON_PROC			--Summon creature procedure
DM_EFFECT_TO_GRAVE_REDIRECT			=EFFECT_REMOVE_REDIRECT			--Put a card into another zone instead of the graveyard
DM_EFFECT_CANNOT_ATTACK_PLAYER		=EFFECT_CANNOT_DIRECT_ATTACK	--Cannot attack player
DM_EFFECT_ATTACK_PLAYER				=EFFECT_DIRECT_ATTACK			--Attack player
DM_EFFECT_CANNOT_BE_TAPPED			=EFFECT_CANNOT_CHANGE_POS_E		--Cannot be tapped by a player's spell or ability
DM_EFFECT_UPDATE_POWER				=EFFECT_UPDATE_ATTACK			--Increase or decrease a creature's power
DM_EFFECT_SET_POWER					=EFFECT_SET_ATTACK				--Creature's power becomes a particular value
DM_EFFECT_UPDATE_PLAY_COST			=EFFECT_UPDATE_LEVEL			--Increase or decrease the cost required for playing a card
DM_EFFECT_CHANGE_MANA_COST			=EFFECT_CHANGE_LEVEL			--Mana cost becomes a particular value
DM_EFFECT_ADD_CIVILIZATION			=EFFECT_ADD_ATTRIBUTE			--Card is considered to be a card of another civilization
DM_EFFECT_CHANGE_CIVILIZATION		=EFFECT_CHANGE_ATTRIBUTE		--Civilization becomes another civilization
DM_EFFECT_ADD_RACE 					=EFFECT_ADD_SETCODE				--Creature is a particular race in addition to its other races
DM_EFFECT_MUST_ATTACK_CREATURE		=EFFECT_MUST_ATTACK_MONSTER		--Creature attacks a creature if able
DM_EFFECT_BROKEN_SHIELD				=24000000						--Register a broken shield
DM_EFFECT_IGNORE_TAP				=24000001						--Workaround to not tap a creature at the end of the damage step
DM_EFFECT_BLOCKED					=CARD_DIA_NORK_MOONLIGHT_GUARDIAN	--Register a creature that has become blocked
DM_EFFECT_BREAK_SHIELD				=CARD_MIRACLE_QUEST				--Register number of broken shields
DM_EFFECT_BLOCKER					=701	--Blocker ("Dia Nork, Moonlight Guardian" DM-01 2/110)
DM_EFFECT_SHIELD_TRIGGER			=702	--Shield Trigger ("Holy Awe" DM-01 6/110)
DM_EFFECT_UNBLOCKABLE				=703	--RESERVED --Cannot be blocked ("Laser Wing" DM-01 11/110)
DM_EFFECT_SLAYER					=704	--Slayer ("Bone Assassin, the Ripper" DM-01 47/110)
DM_EFFECT_BREAKER					=705	--Breaker ("Gigaberos" DM-01 55/110)
DM_EFFECT_DOUBLE_BREAKER			=706	--Double Breaker ("Gigaberos" DM-01 55/110)
DM_EFFECT_POWER_ATTACKER			=707	--Power Attacker ("Brawler Zyler" DM-01 70/110)
DM_EFFECT_UNTAPPED_BE_ATTACKED		=708	--Can be attacked as though it were tapped ("Chaos Strike" DM-01 72/110)
DM_EFFECT_ATTACK_UNTAPPED			=709	--Can attack untapped creatures ("Gatling Skyterror" DM-01 79/110)
DM_EFFECT_CANNOT_ATTACK_CREATURE	=710	--Cannot attack creatures ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_IGNORE_SUMMONING_SICKNESS	=711	--Ignore summoning sickness ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_IGNORE_CANNOT_ATTACK		=712	--Ignore "This creature can't attack" ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_IGNORE_CANNOT_ATTACK_PLAYER	=713--Ignore "This creature can't attack players" ("Diamond Cutter" DM-02 1/55)
DM_EFFECT_TRIPLE_BREAKER			=714	--Triple Breaker ("Bolgash Dragon" DM-05 37/55)
DM_EFFECT_SPEED_ATTACKER			=715	--Speed Attacker ("Bombat, General of Speed" DM-05 38/55)
DM_EFFECT_ENTER_BZONE_TAPPED		=716	--Creature is put into the battle zone tapped ("Lu Gila, Silver Rift Guardian" DM-06 2/110)
DM_EFFECT_NO_BLOCK_BATTLE			=717	--No battle happens when a creature blocks ("Chekicul, Vizier of Endurance" DM-06 15/110)
DM_EFFECT_CANNOT_SUMMON				=718	--Cannot summon a creature ("Gariel, Elemental of Sunbeams" DM-06 20/110)
DM_EFFECT_CHANGE_SHIELD_BREAK_PLAYER=719	--You choose the shield to break when an opponent's creature would break a shield ("Kyuroro" DM-06 36/110)
DM_EFFECT_NO_BE_BLOCKED_BATTLE		=720	--No battle happens when a creature becomes blocked ("Badlands Lizard" DM-06 74/110)
DM_EFFECT_CREW_BREAKER				=721	--Crew Breaker ("Q-tronic Gargantua" DM-06 86/110)
DM_EFFECT_EVOLUTION_ANY_RACE		=722	--Can put an evolution creature of any race on a creature with this ability ("Innocent Hunter, Blade of All" DM-06 103/110)
DM_EFFECT_BREAK_SHIELD_REPLACE		=723	--When a creature would break a shield, do something else to that shield instead ("Bolmeteus Steel Dragon" DM-06 S7/S10)
DM_EFFECT_STEALTH					=724	--Stealth ("Kizar Basiku, the Outrageous" DM-07 9/55)
DM_EFFECT_CHARGER					=725	--Charger ("Lightning Charger" DM-07 15/55)
DM_EFFECT_DONOT_DISCARD_SHIELD_TRIGGER	=726--Do not discard a spell after using its "Shield Trigger" ability ("Super Terradragon Bailas Gale" DM-08 S5/S5)
DM_EFFECT_MUST_BLOCK				=727	--Creature must block another creature if able ("Storm Wrangler, the Furious" DM-09 51/55)
DM_EFFECT_SILENT_SKILL				=728	--Keep creature tapped during untap step to use its "Silent Skill" ability ("Kejila, the Hidden Horror" DM-10 5/110)
DM_EFFECT_PLAYER_CANNOT_UNTAP_START_STEP=729--Player cannot untap cards in their mana zone at the start of each of their turns ("Terradragon Cusdalf" DM-10 93/110)
DM_EFFECT_WAVE_STRIKER				=730	--Wave Striker ("Asra, Vizier of Safety" DM-11 6/55)
DM_EFFECT_DONOT_UNTAP_START_STEP	=731	--Does not untap at the start of the turn ("Warped Lunatron" DM-11 23/55)
DM_EFFECT_CANNOT_USE_TAP_ABILITY	=732	--Player cannot use the Tap ability of their creatures ("Lockdown Lizard" DM-11 39/55)
DM_EFFECT_VORTEX_EVOLUTION			=733	--Vortex Evolution ("Soul Phoenix, Avatar of Unity" DM-12 5/55)
DM_EFFECT_EVOLUTION_SOURCE_REMAIN	=734	--When an evolution creature would leave the battle zone, only the top card leaves instead ("Soul Phoenix, Avatar of Unity" DM-12 5/55)
DM_EFFECT_CHANGE_SHIELD_CHOOSE_PLAYER	=735--When your opponent would choose your shield, you choose instead ("Meloppe" DM-12 9/55)
DM_EFFECT_BREAK_EXTRA_SHIELD		=736	--Breaks one more shield ("Dyno Mantis, the Mightspinner" L10 Y2)
DM_EFFECT_SYMPATHY					=737	--Sympathy ("Akashic First, Electro-Dragon" DM-13 3/55)
DM_EFFECT_CONFIRM_BROKEN_SHIELD		=738	--Player reveals their shields broken by their opponent's creatures ("Rubels, the Explorer" DM-13 36/55)
DM_EFFECT_CHARGE_TAPPED				=739	--Put a cast spell with this ability into the mana zone tapped instead of the graveyard ("Pixie Cocoon" DM-13 50/55)
DM_EFFECT_WINS_ALL_BATTLES			=799	--Wins All Battles ("Marshias, Spirit of the Sun" DM-14 S1/S10)		
--Abilities that trigger or actions that occur at the appropriate event
DM_EVENT_UNTAP_STEP					=EVENT_PREDRAW					--Start of Turn Step (Untap Step)
DM_EVENT_ATTACK_SHIELD				=EVENT_PRE_DAMAGE_CALCULATE		--Before an attacking creature breaks the opponent's shield
DM_EVENT_TO_GRAVE					=EVENT_REMOVE					--When a card is put into the graveyard
--DM_EVENT_TO_MZONE					=EVENT_TO_GRAVE					--RESERVED --When a card is put into the mana zone
DM_EVENT_LEAVE_BZONE				=EVENT_LEAVE_FIELD				--When a card leaves the battle zone - DM_EVENT_TO_SZONE
DM_EVENT_COME_INTO_PLAY				=EVENT_SPSUMMON_SUCCESS			--When a creature is put into the battle zone
DM_EVENT_SUMMON						=EVENT_SPSUMMON_SUCCESS			--When a player summons a creature
DM_EVENT_ATTACK_END					=EVENT_DAMAGE_STEP_END			--When a creature finishes its attack
DM_EVENT_BATTLE_END					=EVENT_DAMAGE_STEP_END			--After a battle happens
DM_EVENT_UNTAP_START_STEP			=CARD_WARPED_LUNATRON			--When a player untaps their cards at the start of their turn
DM_EVENT_TRIGGER_SHIELD_TRIGGER		=CARD_HOLY_AWE					--Trigger a card's "Shield Trigger" ability
DM_EVENT_WIN_BATTLE					=CARD_BLOODY_SQUITO				--When a creature wins a battle + EVENT_BATTLE_DESTROYING
DM_EVENT_LOSE_BATTLE				=CARD_GASHI_GASHI				--When a creature loses a battle + EVENT_BATTLE_DESTROYED
DM_EVENT_BECOME_BLOCKED				=CARD_CREEPING_PLAGUE			--When a creature becomes blocked
DM_EVENT_ATTACK_PLAYER				=CARD_MARROW_OOZE_THE_TWISTER	--When a creature attacks a player
DM_EVENT_BREAK_SHIELD				=CARD_BRUTAL_CHARGE				--When a creature finishes attacking the opponent and broke a shield
DM_EVENT_EVOLUTION_TO_BZONE			=CARD_KACHUA_KEEPER				--When an evolution creature is put into the battle zone by effect
DM_EVENT_TRIGGER_BLOCKER			=CARD_STORM_WRANGLER_THE_FURIOUS--Trigger a creature's "Blocker" ability
DM_EVENT_CAST_FREE					=CARD_BLUUM_ERKIS_FLARE_GUARDIAN--Cast a spell immediately for no cost
DM_EVENT_TO_SZONE					=CARD_SOUL_PHOENIX				--RESERVED --When a card is added to a player's shields
DM_EVENT_BECOME_SHIELD_TRIGGER		=CARD_WOLFIS_BLUE_DIVINE_DRAGON	--Card gets "Shield Trigger" (Can be summoned or cast for no cost)
--Category (for SetCategory)
DM_CATEGORY_BLOCKER					=0x10000000		--"Blocker", needed for unblockable abilities ("Laser Wing" DM-01 11/110)
DM_CATEGORY_SHIELD_TRIGGER			=0x800			--"Shield Trigger" ("Emperor Quazla" DM-08 S2/S5)
--Description (for SetDescription, Duel.Hint)
DM_DESC_NOBZONES					=aux.Stringid(24000000,3)		--"You may have up to 5 creatures in the battle zone when playing with this app.\nHowever, there is no limit when playing the actual card game."
DM_DESC_NOSZONES					=aux.Stringid(24000000,4)		--"You may have up to 5 shields when playing with this app.\nHowever, there is no limit when playing the actual card game."
DM_DESC_NOTARGETS					=aux.Stringid(24000000,5)		--"There is no applicable card."
DM_DESC_NOSTRIGGER					=aux.Stringid(24000000,6)		--"There is no "Shield Trigger" ability that can be activated during this time."
DM_DESC_BROKEN						=300	--"Broken shield"
DM_DESC_SUMMONSICKNESS				=301	--"Summoning Sickness"
DM_DESC_CANNOTATTACK				=302	--"Can't attack"
DM_DESC_SUMMON						=2		--"Summon"
DM_DESC_EVOLUTION					=1199	--"Evolve a creature(s) in the battle zone."
DM_DESC_BLOCKED						=1650	--"Your creature has been blocked!"
DM_DESC_BLOCKER						=1660	--"Blocker (Whenever an opponent's creature attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)"
--DM_DESC_SHIELD_TRIGGER_SPELL		=1661	--RESERVED --"Shield Trigger (When this spell is put into your hand from your shield zone, you may cast it immediately for no cost.)"
DM_DESC_SLAYER						=1662	--"Slayer (Whenever this creature battles, destroy the other creature after the battle.)"
DM_DESC_SHIELD_TRIGGER_CREATURE		=1663	--"Shield Trigger (When this creature is put into your hand from your shield zone, you may summon it immediately for no cost.)"
DM_DESC_FIRE_NATURE_BLOCKER			=1664	--"Fire and nature blocker (Whenever an opponent's fire or nature creature attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)"
DM_DESC_NATURE_LIGHT_SLAYER			=1665	--"Nature and light slayer (Whenever this creature battles a nature or light creature, destroy the other creature after the battle.)"
DM_DESC_SHIELD_SAVER				=1666	--"Shield Saver (When one of your shields would be broken, you may destroy this creature instead.)"
DM_DESC_TURBO_RUSH					=1667	--"Turbo rush (If any of your other creatures broke any shields this turn, this creature gets its Turborush ability until the end of the turn.)"
DM_DESC_DRAGON_BLOCKER				=1668	--"Dragon blocker (Whenever an opponent's creature that has Dragon in its race attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)"
DM_DESC_DARKNESS_BLOCKER			=1669	--"Darkness blocker (Whenever an opponent's darkness creature attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)"
DM_DESC_LIGHT_BLOCKER				=1670	--"Light blocker (Whenever an opponent's light creature attacks, you may tap this creature to stop the attack. Then the 2 creatures battle.)"
--DM_DESC_NON_BREAKER					=1800	--RESERVED --"This creature breaks 1 shield."
DM_DESC_DOUBLE_BREAKER				=1801	--"Double Breaker (This creature breaks 2 shields.)"
DM_DESC_TRIPLE_BREAKER				=1802	--"Triple Breaker (This creature breaks 3 shields.)"
DM_DESC_CREW_BREAKER				=1803	--"Crew Breaker—"RACE" (This creature breaks one more shield for each of your other "RACE" in the battle zone.)"
DM_DECKERROR_DECKCOUNT				=1450	--"Your deck must be exactly 40 cards!"
DM_DECKERROR_NONDM					=1451	--"You can't have any non-Duel Masters cards in your deck!"
--Select Message (for Duel.SelectOption)
DM_SELECT_RACE_ANGEL_COMMAND		=aux.Stringid(24000003,4)	--"Angel Command"
DM_SELECT_RACE_ARMORED_DRAGON		=aux.Stringid(24000002,5)	--"Armored Dragon"
DM_SELECT_RACE_ARMORED_WYVERN		=aux.Stringid(24000002,11)	--"Armored Wyvern"
DM_SELECT_RACE_ARMORLOID			=aux.Stringid(24000002,3)	--"Armorloid"
DM_SELECT_RACE_BALLOON_MUSHROOM		=aux.Stringid(24000003,2)	--"Balloon Mushroom"
DM_SELECT_RACE_BEAST_FOLK			=aux.Stringid(24000002,13)	--"Beast Folk"
DM_SELECT_RACE_BERSERKER			=aux.Stringid(24000001,4)	--"Berserker"
DM_SELECT_RACE_BRAIN_JACKER			=aux.Stringid(24000001,14)	--"Brain Jacker"
DM_SELECT_RACE_CHIMERA				=aux.Stringid(24000002,0)	--"Chimera"
DM_SELECT_RACE_COLONY_BEETLE		=aux.Stringid(24000002,15)	--"Colony Beetle"
DM_SELECT_RACE_CYBER_CLUSTER		=aux.Stringid(24000001,8)	--"Cyber Cluster"
DM_SELECT_RACE_CYBER_LORD			=aux.Stringid(24000001,7)	--"Cyber Lord"
DM_SELECT_RACE_CYBER_MOON			=aux.Stringid(24000001,9)	--"Cyber Moon"
DM_SELECT_RACE_CYBER_VIRUS			=aux.Stringid(24000001,6)	--"Cyber Virus"
DM_SELECT_RACE_DARK_LORD			=aux.Stringid(24000002,2)	--"Dark Lord"
DM_SELECT_RACE_DEATH_PUPPET			=aux.Stringid(24000003,15)	--"Death Puppet"
DM_SELECT_RACE_DEMON_COMMAND		=aux.Stringid(24000003,5)	--"Demon Command"
DM_SELECT_RACE_DEVIL_MASK			=aux.Stringid(24000003,14)	--"Devil Mask"
DM_SELECT_RACE_DRAGO_NOID			=aux.Stringid(24000002,10)	--"Dragonoid"
DM_SELECT_RACE_DUNE_GECKO			=aux.Stringid(24000004,0)	--"Dune Gecko"
DM_SELECT_RACE_EARTH_DRAGON			=aux.Stringid(24000002,8)	--"Earth Dragon"
DM_SELECT_RACE_EARTH_EATER			=aux.Stringid(24000003,13)	--"Earth Eater"
DM_SELECT_RACE_FIRE_BIRD			=aux.Stringid(24000003,8)	--"Fire Bird"
DM_SELECT_RACE_FISH					=aux.Stringid(24000001,10)	--"Fish"
DM_SELECT_RACE_GEL_FISH				=aux.Stringid(24000001,11)	--"Gel Fish"
DM_SELECT_RACE_GHOST				=aux.Stringid(24000001,13)	--"Ghost"
DM_SELECT_RACE_GIANT				=aux.Stringid(24000003,0)	--"Giant"
DM_SELECT_RACE_GIANT_INSECT			=aux.Stringid(24000003,1)	--"Giant Insect"
DM_SELECT_RACE_GLADIATOR			=aux.Stringid(24000003,12)	--"Gladiator"
DM_SELECT_RACE_GUARDIAN				=aux.Stringid(24000001,1)	--"Guardian"
DM_SELECT_RACE_HEDRIAN				=aux.Stringid(24000003,7)	--"Hedrian"
DM_SELECT_RACE_HORNED_BEAST			=aux.Stringid(24000003,3)	--"Horned Beast"
DM_SELECT_RACE_HUMAN				=aux.Stringid(24000002,9)	--"Human"
DM_SELECT_RACE_INITIATE				=aux.Stringid(24000001,3)	--"Initiate"
DM_SELECT_RACE_LEVIATHAN			=aux.Stringid(24000001,12)	--"Leviathan"
DM_SELECT_RACE_LIGHT_BRINGER		=aux.Stringid(24000001,0)	--"Light Bringer"
DM_SELECT_RACE_LIQUID_PEOPLE		=aux.Stringid(24000001,5)	--"Liquid People"
DM_SELECT_RACE_LIVING_DEAD			=aux.Stringid(24000001,15)	--"Living Dead"
DM_SELECT_RACE_MACHINE_EATER		=aux.Stringid(24000002,4)	--"Machine Eater"
DM_SELECT_RACE_MECHA_DEL_SOL		=aux.Stringid(24000004,4)	--"Mecha Del Sol"
DM_SELECT_RACE_MECHA_THUNDER		=aux.Stringid(24000003,6)	--"Mecha Thunder"
DM_SELECT_RACE_MELT_WARRIOR			=aux.Stringid(24000004,8)	--"Melt Warrior"
DM_SELECT_RACE_MERFOLK				=aux.Stringid(24000004,6)	--"Merfolk"
DM_SELECT_RACE_MYSTERY_TOTEM		=aux.Stringid(24000004,2)	--"Mystery Totem"
DM_SELECT_RACE_NAGA					=aux.Stringid(24000004,13)	--"Naga"
DM_SELECT_RACE_PANDORAS_BOX			=aux.Stringid(24000004,7)	--"Pandora's Box"
DM_SELECT_RACE_PARASITE_WORM		=aux.Stringid(24000002,1)	--"Parasite Worm"
DM_SELECT_RACE_PEGASUS				=aux.Stringid(24000004,14)	--"Pegasus"
DM_SELECT_RACE_PHOENIX				=aux.Stringid(24000004,11)	--"Phoenix"
DM_SELECT_RACE_RAINBOW_PHANTOM		=aux.Stringid(24000003,11)	--"Rainbow Phantom"
DM_SELECT_RACE_ROCK_BEAST			=aux.Stringid(24000002,12)	--"Rock Beast"
DM_SELECT_RACE_SEA_HACKER			=aux.Stringid(24000003,10)	--"Sea Hacker"
DM_SELECT_RACE_SNOW_FAERIE			=aux.Stringid(24000004,3)	--"Snow Faerie"
DM_SELECT_RACE_SOLTROOPER			=aux.Stringid(24000004,5)	--"Soltrooper"
DM_SELECT_RACE_SPIRIT_QUARTZ		=aux.Stringid(24000004,10)	--"Spirit Quartz"
DM_SELECT_RACE_STARLIGHT_TREE		=aux.Stringid(24000001,2)	--"Starlight Tree"
DM_SELECT_RACE_STARNOID				=aux.Stringid(24000004,12)	--"Starnoid"
DM_SELECT_RACE_SURVIVOR				=aux.Stringid(24000003,9)	--"Survivor"
DM_SELECT_RACE_TREE_FOLK			=aux.Stringid(24000002,14)	--"Tree Folk"
DM_SELECT_RACE_VOLCANO_DRAGON		=aux.Stringid(24000002,6)	--"Volcano Dragon"
DM_SELECT_RACE_WILD_VEGGIES			=aux.Stringid(24000004,9)	--"Wild Veggies"
DM_SELECT_RACE_XENOPARTS			=aux.Stringid(24000004,1)	--"Xenoparts"
DM_SELECT_RACE_ZOMBIE_DRAGON		=aux.Stringid(24000002,7)	--"Zombie Dragon"
--Hint Message
DM_HINTMSG_DISCARD					=501	--"Choose a card to discard."
DM_HINTMSG_DESTROY					=502	--"Choose a card to destroy."
DM_HINTMSG_TOGRAVE					=503	--"Choose a card to put into the graveyard."
DM_HINTMSG_TOMZONE					=504	--"Choose a card to put into the mana zone."
DM_HINTMSG_RTOHAND					=505	--"Choose a card to return to its owner's hand."
DM_HINTMSG_ATOHAND					=506	--"Choose a card to put into your hand."
DM_HINTMSG_TODECK					=507	--"Choose a card to return to its owner's deck."
DM_HINTMSG_TOBZONE					=509	--"Choose a creature to put into the battle zone."
DM_HINTMSG_CONFIRM					=526	--"Choose a card to look at it."
DM_HINTMSG_TOSZONE					=527	--"Choose a card to add to its owner's shields."
DM_HINTMSG_ATTACKTARGET				=549	--"Choose a creature to attack."
DM_HINTMSG_TARGET					=551	--"Choose a target for the ability."
DM_HINTMSG_APPLYABILITY				=556	--"Choose an ability to apply."
DM_HINTMSG_CIVILIZATION				=562	--"Choose a civilization(s)."
DM_HINTMSG_RACE						=563	--"Choose a race."
DM_HINTMSG_NAME						=564	--"Name a card."
DM_HINTMSG_NUMBER					=565	--"Choose a number."
DM_HINTMSG_TAP						=601	--"Choose a card to tap."
DM_HINTMSG_UNTAP					=602	--"Choose a card to untap."
DM_HINTMSG_BREAK					=603	--"Choose a shield to break."
DM_HINTMSG_CREATURE					=604	--"Choose a creature."
DM_HINTMSG_EVOLVE					=605	--"Choose a creature to evolve."
--Question Hint Message (for Duel.SelectYesNo)
DM_QHINTMSG_DRAW					=700	--"Draw a card?"
DM_QHINTMSG_CARD					=701	--"How many cards?"
DM_QHINTMSG_CHOOSE					=702	--"Choose a card?"
DM_QHINTMSG_TOMZONE					=703	--"Put a card into your mana zone?"
DM_QHINTMSG_TOSZONE					=704	--"Add a card to your shields?"
DM_QHINTMSG_TOHAND					=705	--"Put a card into its owner's hand?"
--DM_QHINTMSG_TAP						=706	--RESERVED --"Tap a card?"
DM_QHINTMSG_UNTAP					=707	--"Untap a card?"
--Timing
DM_TIMING_BATTLE					=TIMING_BATTLE_START+TIMING_BATTLE_END+TIMING_BATTLE_PHASE+TIMING_BATTLE_STEP_END	--Timing for abilities that can trigger during the Attack Step
--Deck Sequence (as parameter)
DECK_SEQUENCE_TOP					=0		--seq=DECK_SEQUENCE_TOP in Duel.SendtoDeck(targets, player, seq, reason)
DECK_SEQUENCE_BOTTOM				=1		--seq=DECK_SEQUENCE_BOTTOM in Duel.SendtoDeck(targets, player, seq, reason)
DECK_SEQUENCE_SHUFFLE				=2		--seq=DECK_SEQUENCE_SHUFFLE in Duel.SendtoDeck(targets, player, seq, reason)
DECK_SEQUENCE_UNEXIST				=-2		--seq=DECK_SEQUENCE_UNEXIST in Duel.SendtoDeck(targets, player, seq, reason)
--Zone (Location + Sequence)
ZONE_ANY							=0xff	--zone=ZONE_ANY in Duel.SendtoBZone(targets, sumtype, sumplayer, target_player, nocheck, nolimit, pos, zone)
MDPro4DMConstants=DMTCG
return DMTCG
