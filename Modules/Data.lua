-- Path of Building
--
-- Module: Data
-- Contains static data used by other modules.
--

data = { }

ModFlag = { }
-- Damage modes
ModFlag.Attack =	 0x00000001
ModFlag.Spell =		 0x00000002
ModFlag.Hit =		 0x00000004
ModFlag.Dot =		 0x00000008
-- Damage sources
ModFlag.Melee =		 0x00000010
ModFlag.Area =		 0x00000020
ModFlag.Projectile = 0x00000040
ModFlag.SourceMask = 0x00000060
-- Weapon types
ModFlag.Axe =		 0x00001000
ModFlag.Bow =		 0x00002000
ModFlag.Claw =		 0x00004000
ModFlag.Dagger =	 0x00008000
ModFlag.Mace =		 0x00010000
ModFlag.Staff =		 0x00020000
ModFlag.Sword =		 0x00040000
ModFlag.Wand =		 0x00080000
ModFlag.Unarmed =	 0x00100000
-- Weapon classes
ModFlag.WeaponMelee =0x00200000
ModFlag.WeaponRanged=0x00400000
ModFlag.Weapon =	 0x00800000
ModFlag.Weapon1H =	 0x01000000
ModFlag.Weapon2H =	 0x02000000

KeywordFlag = { }
-- Skill keywords
KeywordFlag.Aura =		0x000001
KeywordFlag.Curse =		0x000002
KeywordFlag.Warcry =	0x000004
KeywordFlag.Movement =	0x000008
KeywordFlag.Fire =		0x000010
KeywordFlag.Cold =		0x000020
KeywordFlag.Lightning =	0x000040
KeywordFlag.Chaos =		0x000080
KeywordFlag.Vaal =		0x000100
-- Skill types
KeywordFlag.Trap =		0x001000
KeywordFlag.Mine =		0x002000
KeywordFlag.Totem =		0x004000
KeywordFlag.Minion =	0x008000
-- Skill effects
KeywordFlag.Poison =	0x010000
KeywordFlag.Bleed =		0x020000

-- Active skill types, used in ActiveSkills.dat and GrantedEffects.dat
-- Had to reverse engineer this, not sure what all of the values mean
SkillType = {
	Attack = 1,
	Spell = 2,
	Projectile = 3, -- Specifically skills which fire projectiles
	DualWield = 4, -- Attack requires dual wielding, only used on Dual Strike
	Buff = 5,
	CanDualWield = 6, -- Attack can be used while dual wielding
	MainHandOnly = 7, -- Attack only uses the main hand
	Type8 = 8, -- Only used on Cleave, possibly referencing that it combines both weapons when dual wielding
	Minion = 9,
	Hit = 10, -- Skill hits (not used on attacks because all of them hit)
	Area = 11,
	Duration = 12,
	Shield = 13, -- Skill requires a shield
	ProjectileDamage = 14, -- Skill deals projectile damage but doesn't fire projectiles
	ManaCostReserved = 15, -- The skill's mana cost is a reservation
	ManaCostPercent = 16, -- The skill's mana cost is a percentage
	SkillCanTrap = 17, -- Skill can be turned into a trap
	SpellCanTotem = 18, -- Spell can be turned into a totem
	SkillCanMine = 19, -- Skill can be turned into a mine
	CauseElementalStatus = 20, -- Causes elemental status effects, but doesn't hit (used on Herald of Ash to allow Elemental Proliferation to apply)
	CreateMinion = 21, -- Creates or summons minions
	AttackCanTotem = 22, -- Attack can be turned into a totem
	Chaining = 23,
	Melee = 24,
	MeleeSingleTarget = 25,
	SpellCanRepeat = 26, -- Spell can repeat via Spell Echo
	Type27 = 27, -- No idea, used on auras and certain damage skills
	AttackCanRepeat = 28, -- Attack can repeat via Multistrike
	CausesBurning = 29, -- Deals burning damage
	Totem = 30,
	Type31 = 31, -- No idea, used on Molten Shell and the Thunder glove enchants, and added by Blasphemy
	Curse = 32,
	FireSkill = 33,
	ColdSkill = 34,
	LightningSkill = 35,
	TriggerableSpell = 36,
	Trap = 37,
	MovementSkill = 38,
	Cast = 39,
	DamageOverTime = 40,
	Mine = 41,
	TriggeredSpell = 42,
	Vaal = 43,
	Aura = 44,
	LightningSpell = 45, -- Used for Mjolner
	Type46 = 46, -- Doesn't appear to be used at all
	TriggeredAttack = 47,
	ProjectileAttack = 48,
	MinionSpell = 49,
	ChaosSkill = 50,
	Type51 = 51, -- Not used by any skill
	Type52 = 52, -- Allows Contagion to be supported by Iron Will
	Type53 = 53, -- Allows Burning Arrow and Vigilant Strike to be supported by Inc AoE and Conc Effect
	Type54 = 54, -- Not used by any skill
	Type55 = 55, -- Allows Burning Arrow to be supported by Inc/Less Duration and Rapid Decay
	Type56 = 56, -- Not used by any skill
	Type57 = 57, -- Appears to be the same as 47
	Channelled = 58,
	Type59 = 59, -- Allows Contagion to be supported by Controlled Destruction
	ColdSpell = 60, -- Used for Cospri's Malice
}

data.gems = { }
local function makeGemMod(modName, modType, modVal, flags, keywordFlags, ...)
	return {
		name = modName,
		type = modType,
		value = modVal,
		flags = flags or 0,
		keywordFlags = keywordFlags or 0,
		tagList = { ... }
	}
end
local function makeFlagMod(modName)
	return makeGemMod(modName, "FLAG", true)
end
local function makeSkillMod(dataKey, dataValue, ...)
	return makeGemMod("Misc", "LIST", { type = "SkillData", key = dataKey, value = dataValue }, 0, 0, ...)
end
local gemTypes = {
	"act_str",
	"act_dex",
	"act_int",
	"other",
	"sup_str",
	"sup_dex",
	"sup_int",
}
for _, type in pairs(gemTypes) do
	LoadModule("Data/Gems/"..type, data.gems, makeGemMod, makeFlagMod, makeSkillMod)
end
for gemName, gemData in pairs(data.gems) do
	-- Add sources for gem mods
	for _, list in pairs({gemData.baseMods, gemData.qualityMods, gemData.levelMods}) do
		for _, mod in pairs(list) do
			mod.source = "Gem:"..gemName
		end
	end
end

data.colorCodes = {
	NORMAL = "^xC8C8C8",
	MAGIC = "^x8888FF",
	RARE = "^xFFFF77",
	UNIQUE = "^xAF6025",
	CRAFTED = "^xB8DAF1",
	UNSUPPORTED = "^xC05030",
	--FIRE = "^x960000",
	FIRE = "^xD02020",
	--COLD = "^x366492",
	COLD = "^x60A0E7",
	LIGHTNING = "^xFFD700",
	CHAOS = "^xD02090",
	POSITIVE = "^x33FF77",
	NEGATIVE = "^xDD0022",
	OFFENCE = "^xE07030",
	DEFENCE = "^x8080E0",
	SCION = "^xFFF0F0",
	MARAUDER = "^xE05030",
	RANGER = "^x70FF70",
	WITCH = "^x7070FF",
	DUELIST = "^xE0E070",
	TEMPLAR = "^xC040FF",
	SHADOW = "^x30C0D0",
}
data.colorCodes.STRENGTH = data.colorCodes.MARAUDER
data.colorCodes.DEXTERITY = data.colorCodes.RANGER
data.colorCodes.INTELLIGENCE = data.colorCodes.WITCH
data.skillColorMap = { data.colorCodes.STRENGTH, data.colorCodes.DEXTERITY, data.colorCodes.INTELLIGENCE, data.colorCodes.NORMAL }

data.jewelRadius = {
	{ rad = 800, col = "^xBB6600", label = "Small" },
	{ rad = 1200, col = "^x66FFCC", label = "Medium" },
	{ rad = 1500, col = "^x2222CC", label = "Large" }
}

-- Exported data tables:
-- From DefaultMonsterStats.dat
data.monsterEvasionTable = { 36, 42, 49, 56, 64, 72, 80, 89, 98, 108, 118, 128, 140, 151, 164, 177, 190, 204, 219, 235, 251, 268, 286, 305, 325, 345, 367, 389, 412, 437, 463, 489, 517, 546, 577, 609, 642, 676, 713, 750, 790, 831, 873, 918, 964, 1013, 1063, 1116, 1170, 1227, 1287, 1349, 1413, 1480, 1550, 1623, 1698, 1777, 1859, 1944, 2033, 2125, 2221, 2321, 2425, 2533, 2645, 2761, 2883, 3009, 3140, 3276, 3418, 3565, 3717, 3876, 4041, 4213, 4391, 4576, 4768, 4967, 5174, 5389, 5613, 5845, 6085, 6335, 6595, 6864, 7144, 7434, 7735, 8048, 8372, 8709, 9058, 9420, 9796, 10186, }
data.monsterAccuracyTable = { 18, 19, 20, 21, 23, 24, 25, 27, 28, 30, 31, 33, 35, 36, 38, 40, 42, 44, 46, 49, 51, 54, 56, 59, 62, 65, 68, 71, 74, 78, 81, 85, 89, 93, 97, 101, 106, 111, 116, 121, 126, 132, 137, 143, 149, 156, 162, 169, 177, 184, 192, 200, 208, 217, 226, 236, 245, 255, 266, 277, 288, 300, 312, 325, 338, 352, 366, 381, 396, 412, 428, 445, 463, 481, 500, 520, 540, 562, 584, 607, 630, 655, 680, 707, 734, 762, 792, 822, 854, 887, 921, 956, 992, 1030, 1069, 1110, 1152, 1196, 1241, 1288, }
data.monsterLifeTable = { 15, 17, 20, 23, 26, 30, 33, 37, 41, 46, 50, 55, 60, 66, 71, 77, 84, 91, 98, 105, 113, 122, 131, 140, 150, 161, 171, 183, 195, 208, 222, 236, 251, 266, 283, 300, 318, 337, 357, 379, 401, 424, 448, 474, 501, 529, 559, 590, 622, 656, 692, 730, 769, 810, 853, 899, 946, 996, 1048, 1102, 1159, 1219, 1281, 1346, 1415, 1486, 1561, 1640, 1722, 1807, 1897, 1991, 2089, 2192, 2299, 2411, 2528, 2651, 2779, 2913, 3053, 3199, 3352, 3511, 3678, 3853, 4035, 4225, 4424, 4631, 4848, 5074, 5310, 5557, 5815, 6084, 6364, 6658, 6964, 7283, }
-- From MonsterVarieties.dat combined with SkillTotemVariations.dat
data.totemLifeMult = { [1] = 2.94, [2] = 2.94, [3] = 2.94, [4] = 2.94, [5] = 2.94, [6] = 4.2, [7] = 2.94, [8] = 2.94, [9] = 2.94, [10] = 2.94, [11] = 2.94, [12] = 2.94, [13] = 4.5, }

data.weaponTypeInfo = {
	["None"] = { oneHand = true, melee = true, flag = ModFlag.Unarmed },
	["Bow"] = { oneHand = false, melee = false, flag = ModFlag.Bow },
	["Claw"] = { oneHand = true, melee = true, flag = ModFlag.Claw },
	["Dagger"] = { oneHand = true, melee = true, flag = ModFlag.Dagger },
	["Staff"] = { oneHand = false, melee = true, flag = ModFlag.Staff },
	["Wand"] = { oneHand = true, melee = false, flag = ModFlag.Wand },
	["One Handed Axe"] = { oneHand = true, melee = true, flag = ModFlag.Axe },
	["One Handed Mace"] = { oneHand = true, melee = true, flag = ModFlag.Mace },
	["One Handed Sword"] = { oneHand = true, melee = true, flag = ModFlag.Sword },
	["Two Handed Axe"] = { oneHand = false, melee = true, flag = ModFlag.Axe },
	["Two Handed Mace"] = { oneHand = false, melee = true, flag = ModFlag.Mace },
	["Two Handed Sword"] = { oneHand = false, melee = true, flag = ModFlag.Sword },
}

data.unarmedWeaponData = {
	[0] = { attackRate = 1.2, critChance = 0, PhysicalMin = 2, PhysicalMax = 6 }, -- Scion
	[1] = { attackRate = 1.2, critChance = 0, PhysicalMin = 2, PhysicalMax = 8 }, -- Marauder
	[2] = { attackRate = 1.2, critChance = 0, PhysicalMin = 2, PhysicalMax = 5 }, -- Ranger
	[3] = { attackRate = 1.2, critChance = 0, PhysicalMin = 2, PhysicalMax = 5 }, -- Witch
	[4] = { attackRate = 1.2, critChance = 0, PhysicalMin = 2, PhysicalMax = 6 }, -- Duelist
	[5] = { attackRate = 1.2, critChance = 0, PhysicalMin = 2, PhysicalMax = 6 }, -- Templar
	[6] = { attackRate = 1.2, critChance = 0, PhysicalMin = 2, PhysicalMax = 5 }, -- Shadow
}

data.itemBases = { }
data.uniques = { }
data.rares = LoadModule("Data/Rares")
local itemTypes = {
	"axe",
	"bow",
	"claw",
	"dagger",
	"mace",
	"staff",
	"sword",
	"wand",
	"helmet",
	"body",
	"gloves",
	"boots",
	"shield",
	"quiver",
	"amulet",
	"ring",
	"belt",
	"jewel",
}
for _, type in pairs(itemTypes) do
	LoadModule("Data/Bases/"..type, data.itemBases)
	data.uniques[type] = LoadModule("Data/Uniques/"..type)
end

LoadModule("Data/New")