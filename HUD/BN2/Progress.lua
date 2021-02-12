-- Progress values for MMBN 2 scripting, enjoy.

-- TODO: TREZ Post

local progress = {};

progress.scenarios = {
    { value = 0x00; description = "Yai's Fan Collection"    };
    { value = 0x10; description = "Bees, Bears, and Bombs!" };
};

progress[0x00] = "New Game";
progress[0x01] = "Talked to Dex";
progress[0x02] = "Tutorial Done";
progress[0x03] = "ZLicense Exam";
progress[0x04] = "ZLicense Pass";
progress[0x05] = "Talked to Dex";
progress[0x06] = "Ventilator Cleared";
progress[0x07] = "AirMan Deleted";
progress[0x08] = "Gone to bed";

progress[0x10] = "TBD";

progress[0x47] = "Final State";
progress[0x48] = "Credits";

progress[0xFF] = "No Save Data";

return progress;

