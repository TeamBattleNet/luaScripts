-- RAM addresses for MMBN 5 scripting, enjoy.

local addresses = require("All/Addresses");

---------------------------------------- WRAM 02000000-0203FFFF ----------------------------------------

addresses.library               = 0x02000000;

addresses.main_RNG              = 0x02001D40;
addresses.lazy_RNG              = 0x02001C94;

addresses.game_mode             = 0x02000000;
addresses.game_state            = 0x02002940;
addresses.menu_mode             = 0x02000000;
addresses.menu_state            = 0x02000000;

addresses.main_area             = 0x02002944;
addresses.sub_area              = 0x02002945;
addresses.progress              = 0x02002946;
addresses.music_progress        = 0x02002947; -- TBD

addresses.zenny                 = 0x0200299C;
addresses.bug_frags             = 0x02000000; -- TBD

addresses.steps                 = 0x020029BE;
addresses.check                 = 0x020029C0;
addresses.play_time_frames      = 0x020029C4;
addresses.sneak                 = 0x020029D0;

addresses.karma                 = 0x020052EC;

addresses.your_X                = 0x02000000;
addresses.your_Y                = 0x02000000;
addresses.your_X2               = 0x02000000;
addresses.your_Y2               = 0x02000000;

addresses.folder[1].ID          = 0x0202B022;
addresses.folder[1].code        = 0x0202B024; -- TBD

addresses.enemy[1].ID           = 0x02034AE4;
addresses.battle_custom_gauge   = 0x02035700;
addresses.enemy[1].HP           = 0x0203B2FC;
addresses.mega_mood             = 0x0203C88E;
addresses.enemy[1].HP_text      = 0x0203E5C2;

-- 0x0203FFFF end of WRAM

---------------------------------------- ROM  08000000-09FFFFFF ----------------------------------------

---------------------------------------- Verion Dependent ----------------------------------------

-- A0 A1 A2 A3 A4 A5 A6 A7 A8 A9 AA AB AC AD AE AF - ROM Address
-- 52 4F 43 4B 45 58 45 35 5F 54 4F 43 42 52 4B 4A - ROCKEXE5_TOCBRKJ - JP Colonel
-- 52 4F 43 4B 45 58 45 35 5F 54 4F 42 42 52 42 4A - ROCKEXE5_TOBBRBJ - JP Proto
-- 4D 45 47 41 4D 41 4E 35 5F 54 43 5F 42 52 4B 45 - MEGAMAN5_TC_BRKE - US Colonel
-- 4D 45 47 41 4D 41 4E 35 5F 54 50 5F 42 52 42 45 - MEGAMAN5_TP_BRBE - US Proto
-- 4D 45 47 41 4D 41 4E 35 5F 54 43 5F 42 52 4B 50 - MEGAMAN5_TC_BRKP - PAL Colonel
-- 4D 45 47 41 4D 41 4E 35 5F 54 50 5F 42 52 42 50 - MEGAMAN5_TP_BRBP - PAL Proto

local version_byte = memory.read_u32_le(addresses.version_byte);

if     version_byte == 0x4A4B5242 then
    addresses.version_name      = "JP Colonel";
    addresses.encounter_odds    = 0x0801D04E;
    addresses.encounter_curve   = 0x0801D0D6;
elseif version_byte == 0x4A425242 then
    addresses.version_name      = "JP Proto";
    addresses.encounter_odds    = 0x0801D052;
    addresses.encounter_curve   = 0x0801D0DA;
elseif version_byte == 0x454B5242 then
    addresses.version_name      = "US Colonel";
    addresses.encounter_odds    = 0x0801D092;
    addresses.encounter_curve   = 0x0801D11A;
elseif version_byte == 0x45425242 then
    addresses.version_name      = "US Proto";
    addresses.encounter_odds    = 0x0801D096;
    addresses.encounter_curve   = 0x0801D11E;
elseif version_byte == 0x504B5242 then
    addresses.version_name      = "PAL Colonel";
    addresses.encounter_odds    = 0x0801D092;
    addresses.encounter_curve   = 0x0801D11A;
elseif version_byte == 0x50425242 then
    addresses.version_name      = "PAL Proto";
    addresses.encounter_odds    = 0x0801D096;
    addresses.encounter_curve   = 0x0801D11E;
else
    print("\nRAM: Warning! Unrecognized game version! Unable to set certain addresses!");
end

return addresses;
