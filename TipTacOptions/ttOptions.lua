local cfg = TipTac_Config;
local MOD_NAME = ...;
local PARENT_MOD_NAME = "TipTac";

-- get libs
local LibFroznFunctions = LibStub:GetLibrary("LibFroznFunctions-1.0");

-- DropDown Lists
local DROPDOWN_FONTFLAGS = {
	["|cffffa0a0None"] = "",
	["Outline"] = "OUTLINE",
	["Thick Outline"] = "THICKOUTLINE",
};
local DROPDOWN_ANCHORTYPE = {
	["Normal Anchor"] = "normal",
	["Mouse Anchor"] = "mouse",
	["Parent Anchor"] = "parent",
};

local DROPDOWN_ANCHORPOS = {
	["Top"] = "TOP",
	["Top Left"] = "TOPLEFT",
	["Top Right"] = "TOPRIGHT",
	["Bottom"] = "BOTTOM",
	["Bottom Left"] = "BOTTOMLEFT",
	["Bottom Right"] = "BOTTOMRIGHT",
	["Left"] = "LEFT",
	["Right"] = "RIGHT",
	["Center"] = "CENTER",
};

local DROPDOWN_BARTEXTFORMAT = {
	["|cffffa0a0None"] = "none",
	["Percentage"] = "percent",
	["Current Only"] = "current",
	["Values"] = "value",
	["Values & Percent"] = "full",
	["Deficit"] = "deficit",
};

-- Options -- The "y" value of a category subtable, will further increase the vertical offset position of the item
--
-- hint for layouting options:
-- to set pixel perfect scale for options to adjust option elements:
-- /run local psw, psh = GetPhysicalScreenSize(); local uf = 768 / psh; local uis = UIParent:GetEffectiveScale(); local ttos = uf / uis; _G["TipTacOptions"]:SetScale(ttos);
local activePage = 1;
local options = {};
local option;

-- General
local ttOptionsGeneral = {
	{ type = "Check", var = "showUnitTip", label = "Enable TipTac Unit Tip Appearance", tip = "Will change the appearance of how unit tips look. Many options in TipTac only work with this setting enabled.\nNOTE: Using this options with a non English client may cause issues!" },
	
	{ type = "Check", var = "showStatus", label = "Show DC, AFK and DND Status", tip = "Will show the <DC>, <AFK> and <DND> status after the player name", y = 10 },
	{ type = "Check", var = "showTargetedBy", label = "Show Who Targets the Unit", tip = "When in a raid or party, the tip will show who from your group is targeting the unit.\nWhen ungrouped, the visible nameplates (can be enabled under WoW options 'Game->Gameplay->Interface->Nameplates') are evaluated instead." },
	{ type = "Check", var = "showPlayerGender", label = "Show Player Gender", tip = "This will show the gender of the player. E.g. \"85 Female Blood Elf Paladin\"." },
	{ type = "Check", var = "showCurrentUnitSpeed", label = "Show Current Unit Speed", tip = "This will show the current speed of the unit after race & class." }
};

if (C_PlayerInfo.GetPlayerMythicPlusRatingSummary) then
	ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "Check", var = "showMythicPlusDungeonScore", label = "Show Mythic+ Dungeon Score", tip = "This will show the mythic+ dungeon score of the player." };
end

ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "Check", var = "showMount", label = "Show Mount", tip = "This will show the current mount of the player.", y = 10 };
ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "Check", var = "showMountCollected", label = "Collected", tip = "This option makes the tip show an icon indicating if you already have collected the mount.", x = 122 };
ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "Check", var = "showMountIcon", label = "Icon", tip = "This option makes the tip show the mount icon.", x = 210 };
ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "Check", var = "showMountText", label = "Text", tip = "This option makes the tip show the mount text.", x = 122 };
ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "Check", var = "showMountSpeed", label = "Speed", tip = "This option makes the tip show the mount speed.", x = 210 };

ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "DropDown", var = "nameType", label = "Name & Title", list = { ["Name only"] = "normal", ["Name + title"] = "title", ["Copy from original tip"] = "original", ["Mary Sue Protocol"] = "marysueprot" }, y = 10 };
ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "DropDown", var = "showRealm", label = "Show Unit Realm", list = { ["|cffffa0a0Do not show realm"] = "none", ["Show realm"] = "show", ["Show realm in new line"] = "showInNewLine", ["Show (*) instead"] = "asterisk" } };
ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "DropDown", var = "showTarget", label = "Show Unit Target", list = { ["|cffffa0a0Do not show target"] = "none", ["After name"] = "afterName", ["Below name/realm"] = "belowNameRealm", ["Last line"] = "last" } };

ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "Text", var = "targetYouText", label = "Targeting You Text", y = 10 };

ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "Check", var = "showGuild", label = "Show Player Guild", tip = "This will show the guild of the player.", y = 10 };
ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "Check", var = "showGuildRank", label = "Show Player Guild Rank Title", tip = "In addition to the guild name, with this option on, you will also see their guild rank by title and/or level" };
ttOptionsGeneral[#ttOptionsGeneral + 1] = { type = "DropDown", var = "guildRankFormat", label = "Format", list = { ["Title only"] = "title", ["Title + level"] = "both", ["Level only"] = "level" } };

-- Special
local ttOptionsSpecial = {
	{ type = "Check", var = "showBattlePetTip", label = "Enable Battle Pet Tips", tip = "Will show a special tip for both wild and companion battle pets. Might need to be disabled for certain non-English clients" },
	
	{ type = "Slider", var = "gttScale", label = "Tooltip Scale", min = 0.2, max = 4, step = 0.05, y = 10 },
	
	{ type = "Check", var = "enableChatHoverTips", label = "Enable ChatFrame Hover Hyperlinks", tip = "When hovering the mouse over a link in the chatframe, show the tooltip without having to click on it", y = 10 },
	
	{ type = "Header", label = "Strip default text from tooltip" },
	
	{ type = "Check", var = "hidePvpText", label = "Hide PvP Text", tip = "Strips the PvP line from the tooltip" }
};

if (LibFroznFunctions.hasWoWFlavor.specializationAndClassTextInPlayerUnitTip) then
	ttOptionsSpecial[#ttOptionsSpecial + 1] = { type = "Check", var = "hideSpecializationAndClassText", label = "Hide Specialization & Class Text", tip = "Strips the Specialization & Class text from the tooltip" };
end

-- Colors
local ttOptionsColors = {
	{ type = "Check", var = "enableColorName", label = "Enable Coloring of Name", tip = "Turns on or off coloring names" },
	{ type = "Color", var = "colorName", label = "Name Color", tip = "Color of the name, when not using the option to make it the same as reaction color" },
	{ type = "Check", var = "colorNameByReaction", label = "Color Name by Reaction", tip = "Name color will have the same color as the reaction\nNOTE: This option is overridden by class colored name for players" },
	{ type = "Check", var = "colorNameByClass", label = "Color Player Names by Class Color", tip = "With this option on, player names are colored by their class color\nNOTE: This option overrides reaction colored name for players" },
	
	{ type = "Color", var = "colorGuild", label = "Guild Color", tip = "Color of the guild name, when not using the option to make it the same as reaction color", y = 10 },
	{ type = "Color", var = "colorSameGuild", label = "Your Guild Color", tip = "To better recognise players from your guild, you can configure the color of your guild name individually", x = 120 },
	{ type = "Check", var = "colorGuildByReaction", label = "Color Guild by Reaction", tip = "Guild color will have the same color as the reacion" },
	
	{ type = "Color", var = "colorRace", label = "Race & Creature Type Color", tip = "The color of the race and creature type text", y = 10 },
	{ type = "Color", var = "colorLevel", label = "Neutral Level Color", tip = "Units you cannot attack will have their level text shown in this color" },
	
	{ type = "Check", var = "factionText", label = "Show the unit's Faction Text", tip = "With this option on, the faction text of the unit will be shown as text below the level line", y = 10 },
	{ type = "Check", var = "enableColorFaction", label = "Enable Coloring of Faction Text", tip = "Turns on or off coloring faction texts" },
	{ type = "Color", var = "colorFactionAlliance", label = "Alliance Faction Text Color", tip = "Color of the Alliance faction text" },
	{ type = "Color", var = "colorFactionHorde", label = "Horde Faction Text Color", tip = "Color of the Horde faction text" },
	{ type = "Color", var = "colorFactionNeutral", label = "Neutral Faction Text Color", tip = "Color of the Neutral faction text" },
	
	{ type = "Check", var = "classColoredBorder", label = "Color Tip Border by Class Color", tip = "For players, the border color will be colored to match the color of their class\nNOTE: This option overrides reaction colored border", y = 10 },
	
	{ type = "Header", label = "Custom Class Colors" },
	
	{ type = "Check", var = "enableCustomClassColors", label = "Enable Custom Class Colors", tip = "Turns on or off custom class colors" }
};

local numClasses = GetNumClasses();
local firstClass = true;

for i = 1, numClasses do
	local className, classFile = GetClassInfo(i);
	
	if (classFile) then
		local camelCasedClassFile = LibFroznFunctions:CamelCaseText(classFile);
		
		ttOptionsColors[#ttOptionsColors + 1] = { type = "Color", var = "colorCustomClass" .. camelCasedClassFile, label = camelCasedClassFile .. " Color", y = (firstClass and 10 or nil) };
		
		firstClass = false;
	end
end

-- Anchors
local ttOptionsAnchors = {
	{ type = "Check", var = "enableAnchor", label = "Enable Anchor Modifications", tip = "Turns on or off all modifications of the anchor" },
	
	{ type = "DropDown", var = "anchorWorldUnitType", label = "World Unit Type", list = DROPDOWN_ANCHORTYPE, y = 10 },
	{ type = "DropDown", var = "anchorWorldUnitPoint", label = "World Unit Point", list = DROPDOWN_ANCHORPOS },
	
	{ type = "DropDown", var = "anchorWorldTipType", label = "World Tip Type", list = DROPDOWN_ANCHORTYPE, y = 10 },
	{ type = "DropDown", var = "anchorWorldTipPoint", label = "World Tip Point", list = DROPDOWN_ANCHORPOS },
	
	{ type = "DropDown", var = "anchorFrameUnitType", label = "Frame Unit Type", list = DROPDOWN_ANCHORTYPE, y = 10 },
	{ type = "DropDown", var = "anchorFrameUnitPoint", label = "Frame Unit Point", list = DROPDOWN_ANCHORPOS },
	
	{ type = "DropDown", var = "anchorFrameTipType", label = "Frame Tip Type", list = DROPDOWN_ANCHORTYPE, y = 10 },
	{ type = "DropDown", var = "anchorFrameTipPoint", label = "Frame Tip Point", list = DROPDOWN_ANCHORPOS },

	{ type = "Header", label = "Anchor Overrides For In Combat", tip = "Special anchor overrides for in combat" },

	{ type = "Check", var = "enableAnchorOverrideWorldUnitInCombat", label = "World Unit in combat", tip = "This option will override the anchor for World Unit in combat" },
	{ type = "DropDown", var = "anchorWorldUnitTypeInCombat", label = "World Unit Type", list = DROPDOWN_ANCHORTYPE },
	{ type = "DropDown", var = "anchorWorldUnitPointInCombat", label = "World Unit Point", list = DROPDOWN_ANCHORPOS },
	
	{ type = "Check", var = "enableAnchorOverrideWorldTipInCombat", label = "World Tip in combat", tip = "This option will override the anchor for World Tip in combat", y = 10 },
	{ type = "DropDown", var = "anchorWorldTipTypeInCombat", label = "World Tip Type", list = DROPDOWN_ANCHORTYPE },
	{ type = "DropDown", var = "anchorWorldTipPointInCombat", label = "World Tip Point", list = DROPDOWN_ANCHORPOS },
	
	{ type = "Check", var = "enableAnchorOverrideFrameUnitInCombat", label = "Frame Unit in combat", tip = "This option will override the anchor for Frame Unit in combat", y = 10 },
	{ type = "DropDown", var = "anchorFrameUnitTypeInCombat", label = "Frame Unit Type", list = DROPDOWN_ANCHORTYPE },
	{ type = "DropDown", var = "anchorFrameUnitPointInCombat", label = "Frame Unit Point", list = DROPDOWN_ANCHORPOS },
	
	{ type = "Check", var = "enableAnchorOverrideFrameTipInCombat", label = "Frame Tip in combat", tip = "This option will override the anchor for Frame Tip in combat", y = 10 },
	{ type = "DropDown", var = "anchorFrameTipTypeInCombat", label = "Frame Tip Type", list = DROPDOWN_ANCHORTYPE },
	{ type = "DropDown", var = "anchorFrameTipPointInCombat", label = "Frame Tip Point", list = DROPDOWN_ANCHORPOS }
};

if (LibFroznFunctions.hasWoWFlavor.dragonriding) then
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "Header", label = "Anchor Overrides During Dragonriding", tip = "Special anchor overrides during dragonriding" };

	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "Check", var = "enableAnchorOverrideWorldUnitDuringDragonriding", label = "World Unit during dragonriding", tip = "This option will override the anchor for World Unit during dragonriding" };
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "DropDown", var = "anchorWorldUnitTypeDuringDragonriding", label = "World Unit Type", list = DROPDOWN_ANCHORTYPE };
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "DropDown", var = "anchorWorldUnitPointDuringDragonriding", label = "World Unit Point", list = DROPDOWN_ANCHORPOS };
	
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "Check", var = "enableAnchorOverrideWorldTipDuringDragonriding", label = "World Tip during dragonriding", tip = "This option will override the anchor for World Tip during dragonriding", y = 10 };
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "DropDown", var = "anchorWorldTipTypeDuringDragonriding", label = "World Tip Type", list = DROPDOWN_ANCHORTYPE };
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "DropDown", var = "anchorWorldTipPointDuringDragonriding", label = "World Tip Point", list = DROPDOWN_ANCHORPOS };
	
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "Check", var = "enableAnchorOverrideFrameUnitDuringDragonriding", label = "Frame Unit during dragonriding", tip = "This option will override the anchor for Frame Unit during dragonriding", y = 10 };
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "DropDown", var = "anchorFrameUnitTypeDuringDragonriding", label = "Frame Unit Type", list = DROPDOWN_ANCHORTYPE };
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "DropDown", var = "anchorFrameUnitPointDuringDragonriding", label = "Frame Unit Point", list = DROPDOWN_ANCHORPOS };
	
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "Check", var = "enableAnchorOverrideFrameTipDuringDragonriding", label = "Frame Tip during dragonriding", tip = "This option will override the anchor for Frame Tip during dragonriding", y = 10 };
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "DropDown", var = "anchorFrameTipTypeDuringDragonriding", label = "Frame Tip Type", list = DROPDOWN_ANCHORTYPE };
	ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "DropDown", var = "anchorFrameTipPointDuringDragonriding", label = "Frame Tip Point", list = DROPDOWN_ANCHORPOS };
end

ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "Header", label = "Other Anchor Overrides", tip = "Other special anchor overrides" };

ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "Check", var = "enableAnchorOverrideCF", label = "(Guild & Community) ChatFrame", tip = "This option will override the anchor for (Guild & Community) ChatFrame" };
ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "DropDown", var = "anchorOverrideCFType", label = "Tip Type", list = DROPDOWN_ANCHORTYPE };
ttOptionsAnchors[#ttOptionsAnchors + 1] = { type = "DropDown", var = "anchorOverrideCFPoint", label = "Tip Point", list = DROPDOWN_ANCHORPOS };

-- Combat
local ttOptionsCombat = {
	{ type = "Header", label = "Hide Tips Out Of Combat" },
	
	{ type = "Check", var = "hideTipsWorldUnits", label = "Hide World Units", tip = "When you have this option checked, World Units will be hidden." },
	{ type = "Check", var = "hideTipsFrameUnits", label = "Hide Frame Units", tip = "When you have this option checked, Frame Units will be hidden.", x = 160 },
	{ type = "Check", var = "hideTipsWorldTips", label = "Hide World Tips", tip = "When you have this option checked, World Tips will be hidden." },
	{ type = "Check", var = "hideTipsFrameTips", label = "Hide Frame Tips", tip = "When you have this option checked, Frame Tips will be hidden.", x = 160 },
	
	{ type = "Check", var = "hideTipsUnitTips", label = "Hide Unit Tips", tip = "When you have this option checked, Unit Tips will be hidden.", y = 10 },
	{ type = "Check", var = "hideTipsSpellTips", label = "Hide Spell Tips", tip = "When you have this option checked, Spell Tips will be hidden.", x = 160 },
	{ type = "Check", var = "hideTipsItemTips", label = "Hide Item Tips", tip = "When you have this option checked, Item Tips will be hidden." },
	{ type = "Check", var = "hideTipsActionTips", label = "Hide Action Bar Tips", tip = "When you have this option checked, Action Bar Tips will be hidden." },
	
	{ type = "Header", label = "Hide Tips In Combat" },
	
	{ type = "Check", var = "hideTipsInCombatWorldUnits", label = "Hide World Units", tip = "When you have this option checked, World Units will be hidden in combat." },
	{ type = "Check", var = "hideTipsInCombatFrameUnits", label = "Hide Frame Units", tip = "When you have this option checked, Frame Units will be hidden in combat.", x = 160 },
	{ type = "Check", var = "hideTipsInCombatWorldTips", label = "Hide World Tips", tip = "When you have this option checked, World Tips will be hidden in combat." },
	{ type = "Check", var = "hideTipsInCombatFrameTips", label = "Hide Frame Tips", tip = "When you have this option checked, Frame Tips will be hidden in combat.", x = 160 },
	
	{ type = "Check", var = "hideTipsInCombatUnitTips", label = "Hide Unit Tips", tip = "When you have this option checked, Unit Tips will be hidden in combat.", y = 10 },
	{ type = "Check", var = "hideTipsInCombatSpellTips", label = "Hide Spell Tips", tip = "When you have this option checked, Spell Tips will be hidden in combat.", x = 160 },
	{ type = "Check", var = "hideTipsInCombatItemTips", label = "Hide Item Tips", tip = "When you have this option checked, Item Tips will be hidden in combat." },
	{ type = "Check", var = "hideTipsInCombatActionTips", label = "Hide Action Bar Tips", tip = "When you have this option checked, Action Bar Tips will be hidden in combat." }
};

if (LibFroznFunctions.hasWoWFlavor.dragonriding) then
	ttOptionsCombat[#ttOptionsCombat + 1] = { type = "Header", label = "Hide Tips During Dragonriding" };
	
	ttOptionsCombat[#ttOptionsCombat + 1] = { type = "Check", var = "hideTipsDuringDragonridingWorldUnits", label = "Hide World Units", tip = "When you have this option checked, World Units will be hidden during dragonriding." };
	ttOptionsCombat[#ttOptionsCombat + 1] = { type = "Check", var = "hideTipsDuringDragonridingFrameUnits", label = "Hide Frame Units", tip = "When you have this option checked, Frame Units will be hidden during dragonriding.", x = 160 };
	ttOptionsCombat[#ttOptionsCombat + 1] = { type = "Check", var = "hideTipsDuringDragonridingWorldTips", label = "Hide World Tips", tip = "When you have this option checked, World Tips will be hidden during dragonriding." };
	ttOptionsCombat[#ttOptionsCombat + 1] = { type = "Check", var = "hideTipsDuringDragonridingFrameTips", label = "Hide Frame Tips", tip = "When you have this option checked, Frame Tips will be hidden during dragonriding.", x = 160 };
	
	ttOptionsCombat[#ttOptionsCombat + 1] = { type = "Check", var = "hideTipsDuringDragonridingUnitTips", label = "Hide Unit Tips", tip = "When you have this option checked, Unit Tips will be hidden during dragonriding.", y = 10 };
	ttOptionsCombat[#ttOptionsCombat + 1] = { type = "Check", var = "hideTipsDuringDragonridingSpellTips", label = "Hide Spell Tips", tip = "When you have this option checked, Spell Tips will be hidden during dragonriding.", x = 160 };
	ttOptionsCombat[#ttOptionsCombat + 1] = { type = "Check", var = "hideTipsDuringDragonridingItemTips", label = "Hide Item Tips", tip = "When you have this option checked, Item Tips will be hidden during dragonriding." };
	ttOptionsCombat[#ttOptionsCombat + 1] = { type = "Check", var = "hideTipsDuringDragonridingActionTips", label = "Hide Action Bar Tips", tip = "When you have this option checked, Action Bar Tips will be hidden during dragonriding." };
end

ttOptionsCombat[#ttOptionsCombat + 1] = { type = "Header", label = "Others" };

ttOptionsCombat[#ttOptionsCombat + 1] = { type = "DropDown", var = "showHiddenModifierKey", label = "Still Show Hidden Tips\nwhen Holding\nModifier Key", list = { ["Shift"] = "shift", ["Ctrl"] = "ctrl", ["Alt"] = "alt", ["|cffffa0a0None"] = "none" } };
ttOptionsCombat[#ttOptionsCombat + 1] = { type = "TextOnly", label = "", y = -12 }; -- spacer for multi-line label above

-- build options
local options = {
	-- General
	{
		[0] = "General",
		unpack(ttOptionsGeneral)
	},
	-- Special
	{
		[0] = "Special",
		unpack(ttOptionsSpecial)
 	},
	-- Colors
	{
		[0] = "Colors",
		unpack(ttOptionsColors)
	},
	-- Reactions
	{
		[0] = "Reactions",
		{ type = "Check", var = "reactColoredBorder", label = "Color border based on the unit's reaction", tip = "Same as the above option, just for the border\nNOTE: This option is overridden by class colored border" },
		{ type = "Check", var = "reactIcon", label = "Show the unit's reaction as icon", tip = "This option makes the tip show the unit's reaction as an icon right behind the level" },
		
		{ type = "Check", var = "reactText", label = "Show the unit's reaction as text", tip = "With this option on, the reaction of the unit will be shown as text below the level line", y = 10 },
		{ type = "Color", var = "colorReactText", label = "Color of unit's reaction as text", tip = "Color of the unit's reaction as text, when not using the option to make it the same as reaction color" },
		
		{ type = "Check", var = "reactColoredText", label = "Color unit's reaction as text based on unit's reaction", tip = "With this option on, the unit's reaction as text will be based on unit's reaction", y = 10 },
		
		{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.tapped, label = "Tapped Color", y = 10 },
		{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.hostile, label = "Hostile Color" },
		{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.caution, label = "Caution Color" },
		{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.neutral, label = "Neutral Color" },
		{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.friendlyPlayer, label = "Friendly Player Color" },
		{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.friendlyPvPPlayer, label = "Friendly PvP Player Color" },
		{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.friendlyNPC, label = "Friendly NPC Color" },
		{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.honoredNPC, label = "Honored NPC Color" },
		{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.reveredNPC, label = "Revered NPC Color" },
		{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.exaltedNPC, label = "Exalted NPC Color" },
		{ type = "Color", var = "colorReactText" .. LFF_UNIT_REACTION_INDEX.dead, label = "Dead Color" },
	},
	-- BG Color
	{
		[0] = "BG Color",
		{ type = "Check", var = "reactColoredBackdrop", label = "Color backdrop based on the unit's reaction", tip = "If you want the tip's background color to be determined by the unit's reaction towards you, enable this. With the option off, the background color will be the one selected on the 'Backdrop' page" },
		
		{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.tapped, label = "Tapped Color", y = 10 },
		{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.hostile, label = "Hostile Color" },
		{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.caution, label = "Caution Color" },
		{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.neutral, label = "Neutral Color" },
		{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.friendlyPlayer, label = "Friendly Player Color" },
		{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.friendlyPvPPlayer, label = "Friendly PvP Player Color" },
		{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.friendlyNPC, label = "Friendly NPC Color" },
		{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.honoredNPC, label = "Honored NPC Color" },
		{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.reveredNPC, label = "Revered NPC Color" },
		{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.exaltedNPC, label = "Exalted NPC Color" },
		{ type = "Color", var = "colorReactBack" .. LFF_UNIT_REACTION_INDEX.dead, label = "Dead Color" },
	},
	-- Backdrop
	{
		[0] = "Backdrop",
		{ type = "Check", var = "enableBackdrop", label = "Enable Backdrop Modifications", tip = "Turns on or off all modifications of the backdrop\nNOTE: A Reload of the UI (/reload) is required for the setting to take affect" },
		
		{ type = "DropDown", var = "tipBackdropBG", label = "Background Texture", media = "background", y = 10 },
		{ type = "DropDown", var = "tipBackdropEdge", label = "Border Texture", media = "border" },
		
		{ type = "Check", var = "pixelPerfectBackdrop", label = "Pixel Perfect Backdrop Edge Size and Insets", tip = "Backdrop Edge Size and Insets corresponds to real pixels", y = 10 },
		{ type = "Slider", var = "backdropEdgeSize", label = "Backdrop Edge Size", min = -20, max = 64, step = 0.5 },
		{ type = "Slider", var = "backdropInsets", label = "Backdrop Insets", min = -20, max = 20, step = 0.5 },
		
		{ type = "Color", var = "tipColor", label = "Tip Background Color", y = 10 },
		{ type = "Color", var = "tipBorderColor", label = "Tip Border Color", x = 160 },
		{ type = "Check", var = "gradientTip", label = "Show Gradient Tooltips", tip = "Display a small gradient area at the top of the tip to add a minor 3D effect to it. If you have an addon like Skinner, you may wish to disable this to avoid conflicts" },
		{ type = "Color", var = "gradientColor", label = "Gradient Color", tip = "Select the base color for the gradient", x = 160 },
		{ type = "Slider", var = "gradientHeight", label = "Gradient Height", min = 0, max = 64, step = 0.5 },
	},
	-- Font
	{
		[0] = "Font",
		{ type = "Check", var = "modifyFonts", label = "Modify the GameTooltip Font Templates", tip = "For TipTac to change the GameTooltip font templates, and thus all tooltips in the User Interface, you have to enable this option.\nNOTE: If you have an addon such as ClearFont, it might conflict with this option." },
		
		{ type = "DropDown", var = "fontFace", label = "Font Face", media = "font", y = 10 },
		{ type = "DropDown", var = "fontFlags", label = "Font Flags", list = DROPDOWN_FONTFLAGS },
		{ type = "Slider", var = "fontSize", label = "Font Size", min = 6, max = 29, step = 1 },
		
		{ type = "Slider", var = "fontSizeDeltaHeader", label = "Font Size Header Delta", min = -10, max = 10, step = 1, y = 10 },
		{ type = "Slider", var = "fontSizeDeltaSmall", label = "Font Size Small Delta", min = -10, max = 10, step = 1 },
	},
	-- Classify
	{
		[0] = "Classify",
		{ type = "Text", var = "classification_minus", label = "Minus" },
		{ type = "Text", var = "classification_trivial", label = "Trivial" },
		{ type = "Text", var = "classification_normal", label = "Normal" },
		{ type = "Text", var = "classification_elite", label = "Elite" },
		{ type = "Text", var = "classification_worldboss", label = "Boss" },
		{ type = "Text", var = "classification_rare", label = "Rare" },
		{ type = "Text", var = "classification_rareelite", label = "Rare Elite" },
	},
	-- Fading
	{
		[0] = "Fading",
		{ type = "Check", var = "overrideFade", label = "Override Default GameTooltip Fade for Units", tip = "Overrides the default fadeout function of the GameTooltip for units. If you are seeing problems regarding fadeout, please disable." },
		
		{ type = "Slider", var = "preFadeTime", label = "Prefade Time", min = 0, max = 5, step = 0.05, y = 10 },
		{ type = "Slider", var = "fadeTime", label = "Fadeout Time", min = 0, max = 5, step = 0.05 },
		
		{ type = "Check", var = "hideWorldTips", label = "Instantly Hide World Frame Tips", tip = "This option will make most tips which appear from objects in the world disappear instantly when you take the mouse off the object. Examples such as mailboxes, herbs or chests.\nNOTE: Does not work for all world objects.", y = 10 },
	},
	-- Bars
	{
		[0] = "Bars",
		{ type = "Header", label = "Health Bar" },
		
		{ type = "Check", var = "healthBar", label = "Show Health Bar", tip = "Will show a health bar of the unit." },
		{ type = "DropDown", var = "healthBarText", label = "Health Bar Text", list = DROPDOWN_BARTEXTFORMAT },
		{ type = "Color", var = "healthBarColor", label = "Health Bar Color", tip = "The color of the health bar. Has no effect for players with the option above enabled" },
		{ type = "Check", var = "healthBarClassColor", label = "Class Colored Health Bar", tip = "This options colors the health bar in the same color as the player class", y = 2, x = 130 },
		{ type = "Check", var = "hideDefaultBar", label = "Hide the Default Health Bar", tip = "Check this to hide the default health bar" },
		
		{ type = "Header", label = "Mana Bar" },
		
		{ type = "Check", var = "manaBar", label = "Show Mana Bar", tip = "If the unit has mana, a mana bar will be shown." },
		{ type = "DropDown", var = "manaBarText", label = "Mana Bar Text", list = DROPDOWN_BARTEXTFORMAT },
		{ type = "Color", var = "manaBarColor", label = "Mana Bar Color", tip = "The color of the mana bar" },
		
		{ type = "Header", label = "Bar for other Power Types" },
		
		{ type = "Check", var = "powerBar", label = "Show Bar for other Power Types\n(e.g. Energy, Rage, Runic Power or Focus)", tip = "If the unit uses other power types than mana (e.g. energy, rage, runic power or focus), a bar for that will be shown." },
		{ type = "DropDown", var = "powerBarText", label = "Power Bar Text", list = DROPDOWN_BARTEXTFORMAT },
		
		{ type = "Header", label = "Cast Bar" },
		
		{ type = "Check", var = "castBar", label = "Show Cast Bar", tip = "Will show a cast bar of the unit." },
		{ type = "Check", var = "castBarAlwaysShow", label = "Always Show Cast Bar", tip = "Check this to always show the cast bar", x = 130 },
		{ type = "Color", var = "castBarCastingColor", label = "Cast Bar Casting Color", tip = "The casting color of the cast bar", y = 10 },
		{ type = "Color", var = "castBarChannelingColor", label = "Cast Bar Channeling Color", tip = "The channeling color of the cast bar" },
		{ type = "Color", var = "castBarChargingColor", label = "Cast Bar Charging Color", tip = "The charging color of the cast bar" },
		{ type = "Color", var = "castBarCompleteColor", label = "Cast Bar Complete Color", tip = "The complete color of the cast bar" },
		{ type = "Color", var = "castBarFailColor", label = "Cast Bar Fail Color", tip = "The fail color of the cast bar" },
		{ type = "Color", var = "castBarSparkColor", label = "Cast Bar Spark Color", tip = "The spark color of the cast bar" },
		
		{ type = "Header", label = "Others" },
		
		{ type = "Check", var = "barsCondenseValues", label = "Show Condensed Bar Values", tip = "You can enable this option to condense values shown on the bars. It does this by showing 57254 as 57.3k as an example" },
		
		{ type = "DropDown", var = "barFontFace", label = "Font Face", media = "font", y = 10 },
		{ type = "DropDown", var = "barFontFlags", label = "Font Flags", list = DROPDOWN_FONTFLAGS },
		{ type = "Slider", var = "barFontSize", label = "Font Size", min = 6, max = 29, step = 1 },
		
		{ type = "DropDown", var = "barTexture", label = "Bar Texture", media = "statusbar", y = 10 },
		{ type = "Slider", var = "barHeight", label = "Bar Height", min = 1, max = 50, step = 1 },
	},
	-- Auras
	{
		[0] = "Auras",
		{ type = "Check", var = "showBuffs", label = "Show Unit Buffs", tip = "Show buffs of the unit" },
		{ type = "Check", var = "showDebuffs", label = "Show Unit Debuffs", tip = "Show debuffs of the unit" },
		
		{ type = "Check", var = "selfAurasOnly", label = "Only Show Auras Coming from You", tip = "This will filter out and only display auras you cast yourself", y = 10 },
		
		{ type = "Check", var = "showAuraCooldown", label = "Show Cooldown Models", tip = "With this option on, you will see a visual progress of the time left on the buff", y = 10 },
		{ type = "Check", var = "noCooldownCount", label = "No Cooldown Count Text", tip = "Tells cooldown enhancement addons, such as OmniCC, not to display cooldown text" },
		
		{ type = "Slider", var = "auraSize", label = "Aura Icon Dimension", min = 8, max = 60, step = 1, y = 10 },
		{ type = "Slider", var = "auraMaxRows", label = "Max Aura Rows", min = 1, max = 8, step = 1 },
	
		{ type = "Check", var = "aurasAtBottom", label = "Put Aura Icons at the Bottom Instead of Top", tip = "Puts the aura icons at the bottom of the tip instead of the default top", y = 10 },
	},
	-- Icon
	{
		[0] = "Icon",
		{ type = "Check", var = "iconRaid", label = "Show Raid Icon", tip = "Shows the raid icon next to the tip" },
		{ type = "Check", var = "iconFaction", label = "Show Faction Icon", tip = "Shows the faction icon next to the tip, if the unit is flagged for PvP" },
		{ type = "Check", var = "iconCombat", label = "Show Combat Icon", tip = "Shows a combat icon next to the tip, if the unit is in combat" },
		{ type = "Check", var = "iconClass", label = "Show Class Icon", tip = "For players, this will display the class icon next to the tooltip" },
		
		{ type = "DropDown", var = "iconAnchor", label = "Icon Anchor", list = DROPDOWN_ANCHORPOS, y = 10 },
		{ type = "Slider", var = "iconSize", label = "Icon Dimension", min = 8, max = 100, step = 1 },
	},
	-- Anchors
	{
		[0] = "Anchors",
		unpack(ttOptionsAnchors)
	},
	-- Mouse
	{
		[0] = "Mouse",
		{ type = "Slider", var = "mouseOffsetX", label = "Mouse Anchor X Offset", min = -200, max = 200, step = 1 },
		{ type = "Slider", var = "mouseOffsetY", label = "Mouse Anchor Y Offset", min = -200, max = 200, step = 1 },
	},
	-- Combat
	{
		[0] = "Combat",
		unpack(ttOptionsCombat)
	},
	-- Layouts
	{
		[0] = "Layouts",
		{ type = "DropDown", label = "Layout Template", init = TipTacLayouts.LoadLayout_Init },
--		{ type = "Text", label = "Save Layout", func = nil },
--		{ type = "DropDown", label = "Delete Layout", init = TipTacLayouts.DeleteLayout_Init },
	},
};

-- TipTacTalents Support
local TipTacTalents = _G[PARENT_MOD_NAME .. "Talents"];

if (TipTacTalents) then
	local tttOptions = {
		{ type = "Check", var = "t_enable", label = "Enable TipTacTalents", tip = "Turns on or off all features of the TipTacTalents addon" },
		
		{ type = "Header", label = "Talents" },
		
		{ type = "Check", var = "t_showTalents", label = "Show Talents", tip = "This option makes the tip show the talent specialization of other players" },
		
		{ type = "Check", var = "t_talentOnlyInParty", label = "Only Show Talents and Average Item Level\nfor Party and Raid Members", tip = "When you enable this, only talents and average item level of players in your party or raid will be requested and shown", y = 10 }
	};
	
	if (LibFroznFunctions.hasWoWFlavor.roleIconAvailable) then
		tttOptions[#tttOptions + 1] = { type = "Check", var = "t_showRoleIcon", label = "Show Role Icon", tip = "This option makes the tip show the role icon (tank, damager, healer)" };
	end
	if (LibFroznFunctions.hasWoWFlavor.talentIconAvailable) then
		tttOptions[#tttOptions + 1] = { type = "Check", var = "t_showTalentIcon", label = "Show Talent Icon", tip = "This option makes the tip show the talent icon" };
	end
	
	option = { type = "Check", var = "t_showTalentText", label = "Show Talent Text", tip = "This option makes the tip show the talent text", y = 10 };
	if (not LibFroznFunctions.hasWoWFlavor.talentsAvailableForInspectedUnit) then
		option.tip = option.tip .. ".\nNOTE: Inspecting other players' talents isn't available in Classic Era. Only own talents (available at level 10) will be shown.";
	end
	tttOptions[#tttOptions + 1] = option;
	
	tttOptions[#tttOptions + 1] = { type = "Check", var = "t_colorTalentTextByClass", label = "Color Talent Text by Class Color", tip = "With this option on, talent text is colored by their class color" };
	
	if (LibFroznFunctions.hasWoWFlavor.numTalentTrees > 0) then
		if (LibFroznFunctions.hasWoWFlavor.numTalentTrees == 2) then
			tttOptions[#tttOptions + 1] = { type = "DropDown", var = "t_talentFormat", label = "Talent Text Format", list = { ["Elemental (31/30)"] = 1, ["Elemental"] = 2, ["31/30"] = 3,} }; -- not supported with MoP changes
		else
			tttOptions[#tttOptions + 1] = { type = "DropDown", var = "t_talentFormat", label = "Talent Text Format", list = { ["Elemental (57/14/0)"] = 1, ["Elemental"] = 2, ["57/14/0"] = 3,} }; -- not supported with MoP changes
		end
	end
	
	tttOptions[#tttOptions + 1] = { type = "Header", label = "Average Item Level" };
	
	tttOptions[#tttOptions + 1] = { type = "Check", var = "t_showAverageItemLevel", label = "Show Average Item Level (AIL)", tip = "This option makes the tip show the average item level (AIL) of other players" };
	
	tttOptions[#tttOptions + 1] = { type = "Check", var = "t_showGearScore", label = "Show GearScore", tip = "This option makes the tip show TipTac's GearScore of other players", y = 10 };
	tttOptions[#tttOptions + 1] = { type = "DropDown", var = "t_gearScoreAlgorithm", label = "GearScore Algorithm", list = { ["TacoTip"] = { value = 1, tip = "The de-facto standard algorithm from addon TacoTip" }, ["TipTac"] = { value = 2, tip = "TipTac's own implementation to simply calculate the GearScore is used here. This is the sum of all item levels weighted by performance per item level above/below base level of first tier set of current expansion, inventory type and item quality. Inventory slots for shirt, tabard and ranged are excluded." },}, tip = "Switch between different GearScore implementations" };
	
	tttOptions[#tttOptions + 1] = { type = "Check", var = "t_colorAILAndGSTextByQuality", label = "Color Average Item Level and GearScore Text\nby Quality Color", tip = "With this option on, average item level and GearScore text is colored by the quality", y = 10 };
	
	options[#options + 1] = {
		[0] = "Talents/AIL",
		unpack(tttOptions)
	};
end

-- TipTacItemRef Support -- Az: this category page is full -- Frozn45: added scroll frame to config options. the scroll bar appears automatically, if content doesn't fit completely on the page.
local TipTacItemRef = _G[PARENT_MOD_NAME .. "ItemRef"];

if (TipTacItemRef) then
	local ttifOptions = {
		{ type = "Check", var = "if_enable", label = "Enable ItemRefTooltip Modifications", tip = "Turns on or off all features of the TipTacItemRef addon" },
		
		{ type = "Color", var = "if_infoColor", label = "Information Color", tip = "The color of the various tooltip lines added by these options", y = 10 },

		{ type = "Check", var = "if_itemQualityBorder", label = "Show Item Tips with Quality Colored Border", tip = "When enabled and the tip is showing an item, the tip border will have the color of the item's quality", y = 10 },
		{ type = "Check", var = "if_showItemLevel", label = "Show Item Level", tip = "For item tooltips, show their itemLevel (Combines with itemID).\nNOTE: This will remove the default itemLevel text shown in tooltips" },
		{ type = "Check", var = "if_showItemId", label = "Show Item ID", tip = "For item tooltips, show their itemID (Combines with itemLevel)", x = 160 }
	};
	
	if (LibFroznFunctions.hasWoWFlavor.relatedExpansionForItemAvailable) then
		ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showExpansionIcon", label = "Show Expansion Icon", tip = "For item tooltips, show their expansion icon" };
		ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showExpansionName", label = "Show Expansion Name", tip = "For item tooltips, show their expansion name", x = 160 };
	end
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showKeystoneRewardLevel", label = "Show Keystone (Weekly) Reward Level", tip = "For keystone tooltips, show their rewardLevel and weeklyRewardLevel", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showKeystoneTimeLimit", label = "Show Keystone Time Limit", tip = "For keystone tooltips, show the instance timeLimit" };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showKeystoneAffixInfo", label = "Show Keystone Affix Infos", tip = "For keystone tooltips, show the affix infos" };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_modifyKeystoneTips", label = "Modify Keystone Tooltips", tip = "Changes the keystone tooltips to show a bit more information\nWarning: Might conflict with other keystone addons" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_spellColoredBorder", label = "Show Spell Tips with Colored Border", tip = "When enabled and the tip is showing a spell, the tip border will have the standard spell color", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showSpellIdAndRank", label = "Show Spell ID & Rank", tip = "For spell tooltips, show their spellID and spellRank" };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_auraSpellColoredBorder", label = "Show Aura Tips with Colored Border", tip = "When enabled and the tip is showing a buff or debuff, the tip border will have the standard spell color" };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showAuraSpellIdAndRank", label = "Show Aura Spell ID & Rank", tip = "For buff and debuff tooltips, show their spellID and spellRank" };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showMawPowerId", label = "Show Maw Power ID", tip = "For spell and aura tooltips, show their mawPowerID" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showAuraCaster", label = "Show Aura Tooltip Caster", tip = "When showing buff and debuff tooltips, it will add an extra line, showing who cast the specific aura", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_colorAuraCasterByReaction", label = "Color Aura Tooltip Caster by Reaction", tip = "Aura tooltip caster color will have the same color as the reaction\nNOTE: This option is overridden by class colored aura tooltip caster for players" };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_colorAuraCasterByClass", label = "Color Aura Tooltip Caster for Player by Class Color", tip = "With this option on, color aura tooltip caster for players are colored by their class color\nNOTE: This option overrides reaction colored aura tooltip caster for players" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showNpcId", label = "Show NPC ID", tip = "For npc or battle pet tooltips, show their npcID", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showMountId", label = "Show Mount ID", tip = "For item, spell and aura tooltips, show their mountID" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_questDifficultyBorder", label = "Show Quest Tips with Difficulty Colored Border", tip = "When enabled and the tip is showing a quest, the tip border will have the color of the quest's difficulty", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showQuestLevel", label = "Show Quest Level", tip = "For quest tooltips, show their questLevel (Combines with questID)" };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showQuestId", label = "Show Quest ID", tip = "For quest tooltips, show their questID (Combines with questLevel)", x = 160 };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_currencyQualityBorder", label = "Show Currency Tips with Quality Colored Border", tip = "When enabled and the tip is showing a currency, the tip border will have the color of the currency's quality", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showCurrencyId", label = "Show Currency ID", tip = "Currency items will now show their ID" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_achievmentColoredBorder", label = "Show Achievement Tips with Colored Border", tip = "When enabled and the tip is showing an achievement, the tip border will have the the standard achievement color", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showAchievementIdAndCategoryId", label = "Show Achievement ID & Category", tip = "On achievement tooltips, the achievement ID as well as the category will be shown" };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_modifyAchievementTips", label = "Modify Achievement Tooltips", tip = "Changes the achievement tooltips to show a bit more information\nWarning: Might conflict with other achievement addons" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_battlePetQualityBorder", label = "Show Battle Pet Tips with Quality Colored Border", tip = "When enabled and the tip is showing a battle pet, the tip border will have the color of the battle pet's quality", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showBattlePetLevel", label = "Show Battle Pet Level", tip = "For battle bet tooltips, show their petLevel (Combines with npcID)" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_battlePetAbilityColoredBorder", label = "Show Battle Pet Ability Tips with Colored Border", tip = "When enabled and the tip is showing a battle pet ability, the tip border will have the the standard battle pet ability color", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showBattlePetAbilityId", label = "Show Battle Pet Ability ID", tip = "For battle bet ability tooltips, show their abilityID" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_transmogAppearanceItemQualityBorder", label = "Show Transmog Appearance Item Tips with Quality Colored Border", tip = "When enabled and the tip is showing an transmog appearance item, the tip border will have the color of the transmog appearance item's quality", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showTransmogAppearanceItemId", label = "Show Transmog Appearance Item ID", tip = "For transmog appearance item tooltips, show their itemID" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_transmogIllusionColoredBorder", label = "Show Transmog Illusion Tips with Colored Border", tip = "When enabled and the tip is showing a transmog illusion, the tip border will have the the standard transmog illusion color", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showTransmogIllusionId", label = "Show Transmog Illusion ID", tip = "For transmog illusion tooltips, show their illusionID" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_transmogSetQualityBorder", label = "Show Transmog Set Tips with Quality Colored Border", tip = "When enabled and the tip is showing an transmog set, the tip border will have the color of the transmog set's quality", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showTransmogSetId", label = "Show Transmog Set ID", tip = "For transmog set tooltips, show their setID" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_conduitQualityBorder", label = "Show Conduit Tips with Quality Colored Border", tip = "When enabled and the tip is showing a conduit, the tip border will have the color of the conduit's quality", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showConduitItemLevel", label = "Show Conduit Item Level", tip = "For conduit tooltips, show their itemLevel (Combines with conduitID)" };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showConduitId", label = "Show Conduit ID", tip = "For conduit tooltips, show their conduitID (Combines with conduit itemLevel)", x = 160 };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_azeriteEssenceQualityBorder", label = "Show Azerite Essence Tips with Quality Colored Border", tip = "When enabled and the tip is showing an azerite essence, the tip border will have the color of the azerite essence's quality", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showAzeriteEssenceId", label = "Show Azerite Essence ID", tip = "For azerite essence tooltips, show their essenceID" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_runeforgePowerColoredBorder", label = "Show Runeforge Power Tips with Colored Border", tip = "When enabled and the tip is showing a runeforge power, the tip border will have the the standard runeforge power color", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showRuneforgePowerId", label = "Show Runeforge Power ID", tip = "For runeforge power tooltips, show their runeforgePowerID" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_flyoutColoredBorder", label = "Show Flyout Tips with Colored Border", tip = "When enabled and the tip is showing a flyout, the tip border will have the the standard spell color", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showFlyoutId", label = "Show Flyout ID", tip = "For flyout tooltips, show their flyoutID" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_petActionColoredBorder", label = "Show Pet Action Tips with Colored Border", tip = "When enabled and the tip is showing a pet action, the tip border will have the the standard spell color", y = 10 };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showPetActionId", label = "Show Pet Action ID", tip = "For flyout tooltips, show their petActionID" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Header", label = "Icon", tip = "Settings about tooltip icon" };
	
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showIcon", label = "Show Icon Texture and Stack Count (when available)", tip = "Shows an icon next to the tooltip. For items, the stack count will also be shown" };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_smartIcons", label = "Smart Icon Appearance", tip = "When enabled, TipTacItemRef will determine if an icon is needed, based on where the tip is shown. It will not be shown on actionbars or bag slots for example, as they already show an icon" };
	ttifOptions[#ttifOptions + 1] = { type = "DropDown", var = "if_stackCountToTooltip", label = "Show Stack Count in\nTooltip", list = { ["|cffffa0a0Do not show"] = "none", ["Always"] = "always", ["Only if icon is not shown"] = "noicon" } };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_showIconId", label = "Show Icon ID", tip = "For tooltips with icon, show their iconID" };
	ttifOptions[#ttifOptions + 1] = { type = "Check", var = "if_borderlessIcons", label = "Borderless Icons", tip = "Turn off the border on icons" };
	ttifOptions[#ttifOptions + 1] = { type = "Slider", var = "if_iconSize", label = "Icon Size", min = 16, max = 128, step = 1 };
	ttifOptions[#ttifOptions + 1] = { type = "DropDown", var = "if_iconAnchor", label = "Icon Anchor", tip = "The anchor of the icon", list = DROPDOWN_ANCHORPOS };
	ttifOptions[#ttifOptions + 1] = { type = "DropDown", var = "if_iconTooltipAnchor", label = "Icon Tooltip Anchor", tip = "The anchor of the tooltip that the icon should anchor to.", list = DROPDOWN_ANCHORPOS };
	ttifOptions[#ttifOptions + 1] = { type = "Slider", var = "if_iconOffsetX", label = "Icon X Offset", min = -200, max = 200, step = 0.5 };
	ttifOptions[#ttifOptions + 1] = { type = "Slider", var = "if_iconOffsetY", label = "Icon Y Offset", min = -200, max = 200, step = 0.5 };
	
	options[#options + 1] = {
		[0] = "ItemRef",
		unpack(ttifOptions)
	};
end

--------------------------------------------------------------------------------------------------------
--                                          Initialize Frame                                          --
--------------------------------------------------------------------------------------------------------

local f = CreateFrame("Frame",MOD_NAME,UIParent,BackdropTemplateMixin and "BackdropTemplate");	-- 9.0.1: Using BackdropTemplate

UISpecialFrames[#UISpecialFrames + 1] = f:GetName();

f.options = options;

f:SetSize(449,378);
f:SetBackdrop({ bgFile = "Interface\\ChatFrame\\ChatFrameBackground", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 3, right = 3, top = 3, bottom = 3 } });
f:SetBackdropColor(0.1,0.22,0.35,1);
f:SetBackdropBorderColor(0.1,0.1,0.1,1);
f:EnableMouse(true);
f:SetMovable(true);
f:SetFrameStrata("DIALOG");
f:SetToplevel(true);
f:SetClampedToScreen(true);
f:SetScript("OnShow",function(self) self:BuildCategoryPage(); end);
f:Hide();

f.outline = CreateFrame("Frame",nil,f,BackdropTemplateMixin and "BackdropTemplate");	-- 9.0.1: Using BackdropTemplate
f.outline:SetBackdrop({ bgFile = "Interface\\Tooltips\\UI-Tooltip-Background", edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border", tile = 1, tileSize = 16, edgeSize = 16, insets = { left = 4, right = 4, top = 4, bottom = 4 } });
f.outline:SetBackdropColor(0.1,0.1,0.2,1);
f.outline:SetBackdropBorderColor(0.8,0.8,0.9,0.4);
f.outline:SetPoint("TOPLEFT",12,-12);
f.outline:SetPoint("BOTTOMLEFT",12,12);
f.outline:SetWidth(89);

f:SetScript("OnMouseDown",f.StartMoving);
f:SetScript("OnMouseUp",function(self) self:StopMovingOrSizing(); cfg.optionsLeft = self:GetLeft(); cfg.optionsBottom = self:GetBottom(); end);

if (cfg.optionsLeft) and (cfg.optionsBottom) then
	f:SetPoint("BOTTOMLEFT",UIParent,"BOTTOMLEFT",cfg.optionsLeft,cfg.optionsBottom);
else
	f:SetPoint("CENTER");
end

f.header = f:CreateFontString(nil,"ARTWORK","GameFontHighlight");
f.header:SetFont(GameFontNormal:GetFont(),22,"THICKOUTLINE");
f.header:SetPoint("TOPLEFT",f.outline,"TOPRIGHT",9,-4);
f.header:SetText(PARENT_MOD_NAME.." Options");

f.vers = f:CreateFontString(nil,"ARTWORK","GameFontNormalSmall");
f.vers:SetPoint("TOPRIGHT",-15,-15);
local version, build = GetBuildInfo();
f.vers:SetText(PARENT_MOD_NAME .. ": " .. LibFroznFunctions:GetAddOnMetadata(PARENT_MOD_NAME, "Version") .. "\nWoW: " .. version);
f.vers:SetTextColor(1,1,0.5);

f.btnAnchor = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnAnchor:SetSize(75,24);
f.btnAnchor:SetPoint("BOTTOMLEFT",f.outline,"BOTTOMRIGHT",12,2);
local TipTac = _G[PARENT_MOD_NAME];
f.btnAnchor:SetScript("OnClick",function() TipTac:SetShown(not TipTac:IsShown()) end);
f.btnAnchor:SetText("Anchor");

local function Reset_OnClick(self)
	for index, option in ipairs(options[activePage]) do
		if (option.var) then
			cfg[option.var] = nil;	-- when cleared, they will read the default value from the metatable
		end
	end
	TipTac:ApplyConfig();
	f:BuildCategoryPage();
end

f.btnReset = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnReset:SetSize(75,24);
f.btnReset:SetPoint("LEFT",f.btnAnchor,"RIGHT",49,0);
f.btnReset:SetScript("OnClick",Reset_OnClick);
f.btnReset:SetText("Defaults");

f.btnClose = CreateFrame("Button",nil,f,"UIPanelButtonTemplate");
f.btnClose:SetSize(75,24);
f.btnClose:SetPoint("LEFT",f.btnReset,"RIGHT",49,0);
f.btnClose:SetScript("OnClick",function() f:Hide(); end);
f.btnClose:SetText("Close");

local function SetScroll(value)
	local status = f.scrollFrame.status or f.scrollFrame.localstatus;
	local viewheight = f.scrollFrame:GetHeight();
	local height = f.content:GetHeight();
	local offset;

	if viewheight > height then
		offset = 0;
	else
		offset = floor((height - viewheight) / 1000.0 * value);
	end
	f.content:ClearAllPoints();
	f.content:SetPoint("TOPLEFT", 0, offset);
	f.content:SetPoint("TOPRIGHT", 0, offset);
	status.offset = offset;
	status.scrollvalue = value;
end

local function MoveScroll(self, value)
	local status = f.scrollFrame.status or f.scrollFrame.localstatus;
	local height, viewheight = f.scrollFrame:GetHeight(), f.content:GetHeight();

	if self.scrollBarShown then
		local diff = height - viewheight;
		local delta = 1;
		if value < 0 then
			delta = -1;
		end
		f.scrollBar:SetValue(min(max(status.scrollvalue + delta*(1000/(diff/45)),0), 1000));
	end
end

local function FixScroll(self)
	if self.updateLock then return end
	self.updateLock = true;
	local status = f.scrollFrame.status or f.scrollFrame.localstatus;
	local height, viewheight = f.scrollFrame:GetHeight(), f.content:GetHeight();
	local offset = status.offset or 0;
	-- Give us a margin of error of 2 pixels to stop some conditions that i would blame on floating point inaccuracys
	-- No-one is going to miss 2 pixels at the bottom of the frame, anyhow!
	if viewheight < height + 2 then
		if self.scrollBarShown then
			self.scrollBarShown = nil;
			f.scrollBar:Hide();
			f.scrollBar:SetValue(0);
			local scrollFrameBottomRightPoint, scrollFrameBottomRightRelativeTo, scrollFrameBottomRightRelativePoint, scrollFrameBottomRightXOfs, scrollFrameBottomRightYOfs = f.scrollFrame:GetPoint(2);
			scrollFrameBottomRightXOfs = 0;
			f.scrollFrame:SetPoint(scrollFrameBottomRightPoint, scrollFrameBottomRightRelativeTo, scrollFrameBottomRightRelativePoint, scrollFrameBottomRightXOfs, scrollFrameBottomRightYOfs);
			if f.content.original_width then
				f.content:SetWidth(f.content.original_width);
			end
		end
	else
		if not self.scrollBarShown then
			self.scrollBarShown = true;
			f.scrollBar:Show();
			local scrollFrameBottomRightPoint, scrollFrameBottomRightRelativeTo, scrollFrameBottomRightRelativePoint, scrollFrameBottomRightXOfs, scrollFrameBottomRightYOfs = f.scrollFrame:GetPoint(2);
			scrollFrameBottomRightXOfs = -20;
			f.scrollFrame:SetPoint(scrollFrameBottomRightPoint, scrollFrameBottomRightRelativeTo, scrollFrameBottomRightRelativePoint, scrollFrameBottomRightXOfs, scrollFrameBottomRightYOfs);
			if f.content.original_width then
				f.content:SetWidth(f.content.original_width - 20);
			end
		end
		local value = (offset / (viewheight - height) * 1000);
		if value > 1000 then value = 1000 end
		f.scrollBar:SetValue(value);
		SetScroll(value);
		if value < 1000 then
			f.content:ClearAllPoints();
			f.content:SetPoint("TOPLEFT", 0, offset);
			f.content:SetPoint("TOPRIGHT", 0, offset);
			status.offset = offset;
		end
	end
	self.updateLock = nil;
end

local function FixScrollOnUpdate(frame)
	frame:SetScript("OnUpdate", nil);
	FixScroll(frame);
end

local function ScrollFrame_OnMouseWheel(frame, value)
	MoveScroll(frame, value);
end

local function ScrollFrame_OnSizeChanged(frame)
	frame:SetScript("OnUpdate", FixScrollOnUpdate);
end

f.scrollFrame = CreateFrame("ScrollFrame", nil, f);
f.scrollFrame.status = {};
f.scrollFrame:SetPoint("TOPLEFT", f.outline, "TOPRIGHT", 0, -38);
f.scrollFrame:SetPoint("BOTTOMRIGHT", f.btnClose, "TOPRIGHT", 0, 8);
f.scrollFrame:EnableMouseWheel(true);
f.scrollFrame:SetScript("OnMouseWheel", ScrollFrame_OnMouseWheel);
f.scrollFrame:SetScript("OnSizeChanged", ScrollFrame_OnSizeChanged);

local function ScrollBar_OnScrollValueChanged(frame, value)
	SetScroll(value);
end

f.scrollBar = CreateFrame("Slider", nil, f.scrollFrame, "UIPanelScrollBarTemplate");
f.scrollBar:SetPoint("TOPLEFT", f.scrollFrame, "TOPRIGHT", 4, -16);
f.scrollBar:SetPoint("BOTTOMLEFT", f.scrollFrame, "BOTTOMRIGHT", 4, 16);
f.scrollBar:SetMinMaxValues(0, 1000);
f.scrollBar:SetValueStep(1);
f.scrollBar:SetValue(0);
f.scrollBar:SetWidth(16);
f.scrollBar:Hide();
-- set the script as the last step, so it doesn't fire yet
f.scrollBar:SetScript("OnValueChanged", ScrollBar_OnScrollValueChanged);

f.scrollBg = f.scrollBar:CreateTexture(nil, "BACKGROUND");
f.scrollBg:SetAllPoints(f.scrollBar);
f.scrollBg:SetColorTexture(0, 0, 0, 0.4);

--Container Support
f.content = CreateFrame("Frame", nil, f.scrollFrame)
f.content:SetHeight(400);
f.content:SetScript("OnSizeChanged", function(self, ...)
	ScrollFrame_OnSizeChanged(f.scrollFrame, ...);
end);
f.scrollFrame:SetScrollChild(f.content);
f.content:SetPoint("TOPLEFT");
f.content:SetPoint("TOPRIGHT");

--------------------------------------------------------------------------------------------------------
--                                        Options Category List                                       --
--------------------------------------------------------------------------------------------------------

local listButtons = {};

local function CategoryButton_OnClick(self,button)
	listButtons[activePage].text:SetTextColor(1,0.82,0);
	listButtons[activePage]:UnlockHighlight();
	activePage = self.index;
	self.text:SetTextColor(1,1,1);
	self:LockHighlight();
	PlaySound(SOUNDKIT.IG_MAINMENU_OPTION_CHECKBOX_ON);	-- "igMainMenuOptionCheckBoxOn"
	f:BuildCategoryPage();
end

local buttonWidth = (f.outline:GetWidth() - 8);
local function CreateCategoryButtonEntry(parent)
	local b = CreateFrame("Button",nil,parent);
	b:SetSize(buttonWidth,18);
	b:SetScript("OnClick",CategoryButton_OnClick);
	b:SetHighlightTexture("Interface\\QuestFrame\\UI-QuestTitleHighlight");
	b:GetHighlightTexture():SetAlpha(0.7);
	b.text = b:CreateFontString(nil,"ARTWORK","GameFontNormal");
	b.text:SetPoint("LEFT",3,0);
	listButtons[#listButtons + 1] = b;
	return b;
end

for index, table in ipairs(options) do
	local button = listButtons[index] or CreateCategoryButtonEntry(f.outline);
	button.text:SetText(table[0]);
	button.index = index;
	if (index == 1) then
		button:SetPoint("TOPLEFT",f.outline,"TOPLEFT",5,-6);
	else
		button:SetPoint("TOPLEFT",listButtons[index - 1],"BOTTOMLEFT");
	end
	if (index == activePage) then
		button.text:SetTextColor(1,1,1);
		button:LockHighlight();
	end
end

--------------------------------------------------------------------------------------------------------
--                                        Build Option Category                                       --
--------------------------------------------------------------------------------------------------------

-- Get Setting
local function GetConfigValue(self,var)
	return cfg[var];
end

-- called when a setting is changed, do not allow
local function SetConfigValue(self,var,value)
	if (not self.isBuildingOptions) then
		cfg[var] = value;
		local TipTac = _G[PARENT_MOD_NAME];
		TipTac:ApplyConfig();
	end
end

-- create new factory instance
local factory = AzOptionsFactory:New(f.content,GetConfigValue,SetConfigValue);
f.factory = factory; 

-- Build Page
function f:BuildCategoryPage()
	-- update scroll frame
	f.scrollBar:SetValue(0);
	
	-- build page
	factory:BuildOptionsPage(options[activePage], f.content, 0, 0);
	
	-- set new content height
	local contentChildren = { f.content:GetChildren() };
	local newContentHeight = 0;
	local contentChildMostBottom = nil;
	
	for index, contentChild in ipairs(contentChildren) do
		local contentChildTopLeftPoint, contentChildTopLeftRelativeTo, contentChildTopLeftRelativePoint, contentChildTopLeftXOfs, contentChildTopLeftYOfs = contentChild:GetPoint();
		
		if (contentChild:IsShown() and -contentChildTopLeftYOfs >= newContentHeight) then
			newContentHeight = -contentChildTopLeftYOfs;
			contentChildMostBottom = contentChild;
		end
	end
	
	f.content:SetHeight(newContentHeight + contentChildMostBottom:GetHeight());
end