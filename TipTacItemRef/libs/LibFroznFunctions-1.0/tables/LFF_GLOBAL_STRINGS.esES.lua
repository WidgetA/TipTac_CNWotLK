-- df 10.0.5 build 48069, see "GlobalStrings.lua"

-- define table
local TABLE_NAME = "LFF_GLOBAL_STRINGS";
local TABLE_MINOR = 3; -- bump on changes

local LibFroznFunctions = LibStub:GetLibrary("LibFroznFunctions-1.0");

if ((LibFroznFunctions:GetTableVersion(TABLE_NAME) or 0) >= TABLE_MINOR) then
	return;
end

-- create table
LFF_GLOBAL_STRINGS.esES = {
	["RENOWN_REWARD_MOUNT_NAME_FORMAT"] = "Montura: %s",
	["TIPTAC_TIPTAC_DEVELOPER"] = "Desarrollador del addon %s",
	["TIPTAC_TARGETED_BY"] = "Objetivo de"
}
