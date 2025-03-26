-- wotlkc 3.4.3 build 52237, from https://wago.tools/db2/ItemEffect?build=3.4.3.52237 with SpellCategoryID = 330 (Mount), converted to "Lua - Dictionary Table" by itemID with mountID with https://thdoan.github.io/mr-data-converter/

-- define table
local TABLE_NAME = "LFF_ITEMID_TO_MOUNTID_LOOKUP";
local TABLE_MINOR = 2; -- bump on changes

local LibFroznFunctions = LibStub:GetLibrary("LibFroznFunctions-1.0");

if ((LibFroznFunctions:GetTableVersion(TABLE_NAME) or 0) >= TABLE_MINOR) then
	return;
end

-- create table
LibFroznFunctions:ChainTables(LFF_ITEMID_TO_MOUNTID_LOOKUP, {
	[1041]=356,
	[1132]=358,
	[1133]=359,
	[1134]=4268,
	[2411]=308,
	[2413]=306,
	[2414]=307,
	[2415]=305,
	[5655]=4269,
	[5656]=284,
	[5663]=4270,
	[5665]=4271,
	[5668]=4272,
	[5864]=4710,
	[5872]=4779,
	[5873]=4777,
	[5874]=4780,
	[5875]=4778,
	[8563]=7739,
	[8583]=6486,
	[8586]=7704,
	[8588]=6075,
	[8589]=7706,
	[8590]=7703,
	[8591]=7707,
	[8592]=7708,
	[8595]=7749,
	[8627]=7322,
	[8628]=7689,
	[8629]=7690,
	[8630]=7686,
	[8631]=6074,
	[8632]=7687,
	[8633]=7684,
	[12302]=10322,
	[12303]=7322,
	[12325]=10336,
	[12326]=10337,
	[12327]=10338,
	[12330]=4270,
	[12351]=359,
	[12353]=305,
	[12354]=306,
	[13086]=11021,
	[13317]=7706,
	[13321]=11147,
	[13322]=10180,
	[13323]=11148,
	[13324]=11149,
	[13325]=10178,
	[13326]=10179,
	[13327]=11150,
	[13328]=4780,
	[13329]=4778,
	[13331]=11153,
	[13332]=11154,
	[13333]=11155,
	[13334]=11156,
	[13335]=30542,
	[14062]=11689,
	[15277]=12149,
	[15290]=11689,
	[15292]=12151,
	[15293]=12148,
	[16338]=284,
	[16339]=306,
	[16343]=4272,
	[16344]=359,
	[18063]=30542,
	[18241]=14332,
	[18242]=14336,
	[18243]=14334,
	[18244]=14335,
	[18245]=14329,
	[18246]=14330,
	[18247]=14333,
	[18248]=14331,
	[18766]=14556,
	[18767]=14555,
	[18768]=14557,
	[18772]=14553,
	[18773]=14552,
	[18774]=14551,
	[18776]=14559,
	[18777]=14561,
	[18778]=14560,
	[18785]=14547,
	[18786]=14546,
	[18787]=14548,
	[18788]=14545,
	[18789]=14543,
	[18790]=14544,
	[18791]=14558,
	[18793]=14542,
	[18794]=14549,
	[18795]=14550,
	[18796]=14540,
	[18797]=14539,
	[18798]=14541,
	[18902]=14602,
	[19029]=14744,
	[19030]=14745,
	[19872]=15090,
	[19902]=15104,
	[20221]=18768,
	[21044]=15524,
	[21176]=15711,
	[21218]=15666,
	[21321]=15716,
	[21323]=15715,
	[21324]=15714,
	[21736]=16597,
	[23193]=11195,
	[23720]=17266,
	[25470]=18360,
	[25471]=18357,
	[25472]=18359,
	[25473]=18406,
	[25474]=18363,
	[25475]=18364,
	[25476]=18365,
	[25477]=18377,
	[25527]=18376,
	[25528]=18375,
	[25529]=18362,
	[25531]=18378,
	[25532]=18380,
	[25533]=18379,
	[25596]=18545,
	[25664]=18474,
	[27819]=15090,
	[27853]=15090,
	[28481]=19658,
	[28482]=19659,
	[28915]=22511,
	[28927]=19280,
	[28936]=19281,
	[29102]=20072,
	[29103]=20151,
	[29104]=20152,
	[29105]=20150,
	[29220]=20220,
	[29221]=20222,
	[29222]=20217,
	[29223]=20224,
	[29224]=20223,
	[29225]=20225,
	[29227]=20072,
	[29228]=20149,
	[29229]=20152,
	[29230]=20150,
	[29231]=20151,
	[29465]=14334,
	[29466]=14333,
	[29467]=14335,
	[29468]=14332,
	[29469]=14329,
	[29470]=14331,
	[29471]=14336,
	[29472]=14330,
	[29743]=20847,
	[29744]=20846,
	[29745]=20848,
	[29746]=20849,
	[29747]=20850,
	[30480]=21354,
	[30609]=21510,
	[31829]=22510,
	[31830]=22510,
	[31831]=22512,
	[31832]=22512,
	[31833]=22513,
	[31834]=22513,
	[31835]=22514,
	[31836]=22514,
	[32314]=22958,
	[32316]=22975,
	[32317]=22976,
	[32318]=22977,
	[32319]=22978,
	[32458]=18545,
	[32768]=23408,
	[32857]=23455,
	[32858]=23456,
	[32859]=23460,
	[32860]=23458,
	[32861]=23457,
	[32862]=23459,
	[33146]=0,
	[33147]=0,
	[33176]=23952,
	[33179]=30305,
	[33182]=30305,
	[33183]=23966,
	[33184]=30305,
	[33189]=23966,
	[33224]=24003,
	[33225]=24004,
	[33302]=21635,
	[33809]=24379,
	[33976]=23588,
	[33977]=24368,
	[33999]=24488,
	[34060]=24653,
	[34061]=24654,
	[34092]=24743,
	[34129]=20225,
	[34150]=24906,
	[35225]=26192,
	[35226]=26164,
	[35351]=0,
	[35513]=26131,
	[35906]=26439,
	[37011]=23966,
	[37012]=27152,
	[37598]=27541,
	[37676]=27637,
	[37719]=27684,
	[37827]=27706,
	[37828]=27707,
	[38265]=27976,
	[38479]=24653,
	[38576]=28363,
	[38690]=28531,
	[39303]=0,
	[40775]=29582,
	[40777]=29596,
	[41508]=29929,
	[43516]=31124,
	[43599]=31319,
	[43951]=31717,
	[43952]=31694,
	[43953]=31695,
	[43954]=31698,
	[43955]=31697,
	[43956]=31849,
	[43957]=31851,
	[43958]=31855,
	[43959]=31862,
	[43960]=0,
	[43961]=31858,
	[43962]=29596,
	[43963]=31700,
	[43964]=31699,
	[43965]=23460,
	[43986]=31778,
	[44077]=31850,
	[44079]=31852,
	[44080]=31854,
	[44083]=31861,
	[44085]=0,
	[44086]=31857,
	[44151]=32151,
	[44160]=31902,
	[44164]=31912,
	[44168]=32153,
	[44175]=32156,
	[44177]=32157,
	[44178]=32158,
	[44221]=0,
	[44223]=32203,
	[44224]=32205,
	[44225]=32206,
	[44226]=32207,
	[44229]=0,
	[44230]=31851,
	[44231]=31852,
	[44234]=32640,
	[44235]=32633,
	[44413]=32286,
	[44554]=33029,
	[44555]=32634,
	[44556]=32636,
	[44557]=32635,
	[44558]=33030,
	[44604]=23966,
	[44689]=32335,
	[44690]=32336,
	[44707]=32562,
	[44842]=32944,
	[44843]=31239,
	[44857]=25064,
	[44885]=0,
	[45125]=33297,
	[45586]=33408,
	[45589]=33301,
	[45590]=33416,
	[45591]=33298,
	[45592]=33300,
	[45593]=33299,
	[45595]=33409,
	[45596]=33418,
	[45597]=33414,
	[45693]=33848,
	[45725]=33857,
	[45801]=33892,
	[45802]=33904,
	[46099]=356,
	[46100]=34155,
	[46101]=34154,
	[46102]=34156,
	[46171]=34425,
	[46308]=34238,
	[46708]=34225,
	[46743]=34549,
	[46744]=34550,
	[46745]=34551,
	[46746]=34552,
	[46747]=34553,
	[46748]=34554,
	[46749]=34555,
	[46750]=34558,
	[46751]=34556,
	[46752]=34557,
	[46755]=34558,
	[46756]=34551,
	[46757]=34555,
	[46758]=34557,
	[46759]=34550,
	[46760]=34549,
	[46761]=34556,
	[46762]=34554,
	[46763]=34553,
	[46764]=34552,
	[46778]=34655,
	[46813]=35147,
	[46814]=35148,
	[46815]=33840,
	[46816]=33841,
	[47100]=35168,
	[47101]=35169,
	[47179]=35179,
	[47180]=35445,
	[47840]=35362,
	[49044]=35808,
	[49046]=35809,
	[49096]=35876,
	[49098]=35878,
	[49282]=28363,
	[49283]=24003,
	[49284]=24004,
	[49285]=26192,
	[49286]=26164,
	[49290]=34655,
	[49636]=36837,
	[50250]=38204,
	[50435]=38361,
	[50818]=38545,
	[51954]=38778,
	[51955]=38695,
	[52200]=39046,
	[54068]=40191,
	[54069]=40165,
	[54797]=40533,
	[54811]=40625,
	[54860]=40725,
	[184865]=176708,
	[192455]=189739,
	[198628]=26164,
	[198629]=26192,
	[198630]=40165,
	[198631]=34655,
	[198632]=28363,
	[198633]=40191,
	[199931]=196503,
	[201699]=198525,
	[207097]=208033,
	[209946]=211026
});
