-- classic era 1.15.0 build 52610, from https://wago.tools/db2/SpellEffect?build=1.15.0.52610 with Effect = 6 (APPLY_AURA) and EffectAura = 78 (MOUNTED), converted to "Lua - Dictionary Table" by spellID with EffectMiscValue_0 with https://thdoan.github.io/mr-data-converter/

-- define table
local TABLE_NAME = "LFF_SPELLID_TO_MOUNTID_LOOKUP";
local TABLE_MINOR = 2; -- bump on changes

local LibFroznFunctions = LibStub:GetLibrary("LibFroznFunctions-1.0");

if ((LibFroznFunctions:GetTableVersion(TABLE_NAME) or 0) >= TABLE_MINOR) then
	return;
end

LibFroznFunctions:RegisterTableVersion(TABLE_NAME, TABLE_MINOR);

-- create table
LibFroznFunctions:ChainTables(LFF_SPELLID_TO_MOUNTID_LOOKUP, {
	[458]=284,
	[459]=4268,
	[468]=305,
	[470]=308,
	[471]=306,
	[472]=307,
	[578]=356,
	[579]=4270,
	[580]=358,
	[581]=359,
	[3363]=15135,
	[5784]=304,
	[6648]=4269,
	[6653]=4271,
	[6654]=4272,
	[6777]=4710,
	[6896]=4780,
	[6897]=4778,
	[6898]=4777,
	[6899]=4779,
	[8394]=6074,
	[8395]=6075,
	[8396]=6076,
	[8980]=6486,
	[10787]=7322,
	[10788]=7684,
	[10789]=7687,
	[10790]=7686,
	[10792]=7689,
	[10793]=7690,
	[10795]=7706,
	[10796]=7707,
	[10798]=7703,
	[10799]=7708,
	[10800]=7709,
	[10801]=7710,
	[10802]=7711,
	[10803]=7712,
	[10804]=7713,
	[10873]=7739,
	[10969]=7749,
	[13819]=9158,
	[15779]=10179,
	[15780]=10178,
	[15781]=10180,
	[16055]=7322,
	[16056]=10322,
	[16058]=10336,
	[16059]=10337,
	[16060]=10338,
	[16080]=4270,
	[16081]=359,
	[16082]=306,
	[16083]=305,
	[16084]=7704,
	[17229]=11021,
	[17450]=7706,
	[17453]=11147,
	[17454]=10180,
	[17455]=11148,
	[17456]=11149,
	[17458]=10178,
	[17459]=11150,
	[17460]=4778,
	[17461]=4780,
	[17462]=11153,
	[17463]=11154,
	[17464]=11155,
	[17465]=11156,
	[17481]=11195,
	[18363]=11689,
	[18989]=12149,
	[18990]=11689,
	[18991]=12151,
	[18992]=12148,
	[22717]=14332,
	[22718]=14333,
	[22719]=14334,
	[22720]=14335,
	[22721]=14330,
	[22722]=14331,
	[22723]=14336,
	[22724]=14329,
	[23161]=14505,
	[23214]=14565,
	[23219]=14555,
	[23220]=14557,
	[23221]=14556,
	[23222]=14551,
	[23223]=14552,
	[23225]=14553,
	[23227]=14559,
	[23228]=14560,
	[23229]=14561,
	[23238]=14546,
	[23239]=14548,
	[23240]=14547,
	[23241]=14545,
	[23242]=14543,
	[23243]=14544,
	[23246]=14558,
	[23247]=14542,
	[23248]=14550,
	[23249]=14549,
	[23250]=14540,
	[23251]=14539,
	[23252]=14541,
	[23338]=14602,
	[23509]=14744,
	[23510]=14745,
	[24242]=15090,
	[24252]=15104,
	[24576]=15135,
	[25675]=15524,
	[25858]=15665,
	[25859]=15665,
	[25863]=15666,
	[25953]=15713,
	[26054]=15716,
	[26055]=15714,
	[26056]=15715,
	[26332]=15778,
	[26655]=15666,
	[29059]=11195,
	[30174]=17266,
	[31700]=15713,
	[370637]=11195,
	[381598]=11195,
	[406634]=203694,
	[429856]=12361,
	[429857]=5197,
	[434508]=15665
});
