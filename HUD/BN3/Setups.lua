-- Specific Sequences of Inputs for MMBN 3 scripting, enjoy.

local setups = require("All/Setups");

local group_misc = setups.create_group("Miscellaneous");

setups.add_setup(group_misc, "Open & Close Menu", function()
    setups.press_buttons( 2, "Menu", {Start=true});
    setups.press_buttons(20, "Menu");
    setups.press_buttons( 2, "Menu", {A=true});
    setups.press_buttons(40, "Menu");
    setups.press_buttons( 2, "Menu", {B=true});
    setups.press_buttons(60, "Menu");
    setups.press_buttons( 2, "Menu", {B=true});
    setups.press_buttons(30, "Menu");
end);

setups.add_setup(group_misc, "PRESS START", function()
    setups.press_buttons(2, "PRESS START", {Start=true});
    setups.press_buttons(2, "CONTINUE", {A=true});
end);

setups.add_setup(group_misc, "TEST BUTTONS", function()
    --setups.soft_reset(0);
    --setups.hard_reset(0);
    setups.press_buttons(37, "Loading....");
    setups.press_buttons( 1, "PRESS START", {Start=true});
end);

local group_RNG = setups.create_group("RNG Manipulation");

setups.add_setup(group_RNG, "BN1: 359: GutsMan", function()
    setups.soft_reset(); -- RNG Index: 354-364 (359)
    setups.press_buttons(  40, "Area Loading..");
    setups.press_buttons(   1, "Talk to Dex"   , {A=true});
    setups.press_buttons(  20, "Wait on text..");
    setups.press_buttons(   1, "Textbox"       , {A=true});
    setups.press_buttons(  10, "Wait on text..");
    setups.press_buttons(   1, "Textbox"       , {A=true});
    setups.press_buttons(  15, "Wait on text..");
    setups.press_buttons(   1, "Textbox"       , {A=true});
    setups.press_buttons(  20, "Wait on text..");
    setups.press_buttons(   2, "Move to Yes"   , {Left=true});
    setups.press_buttons(   1, "Select Yes"    , {A=true});
    setups.press_buttons(  15, "Wait on text..");
    setups.press_buttons(   1, "Textbox"       , {A=true});
    setups.press_buttons(87+6, "Wait on RNG...");
    setups.press_buttons(   1, "Start fight!"  , {A=true});
end);

setups.add_setup(group_RNG, "BN1: 740: ColorMan", function()
    setups.soft_reset(); -- RNG Index: 735-746 (740)
    setups.press_buttons( 40, "Loading...");
    setups.press_buttons(279, "Wait on RNG...");
    setups.press_buttons(  1, "Jack in to the bus", {R=true});
    setups.press_buttons(400, "Wait on animation...");
    setups.press_buttons(120, "Skip Cutscene...", {Start=true});
end);

local group_folders = setups.create_group("Folder Edits");

setups.add_setup(group_folders, "BN1: Folder  0: Remove All Chips", function()
    for i=1,30 do
        setups.folder_edit_buttons({
            {A=true};
            {A=true};
            {Down=true};
        });
    end
end);

setups.add_setup(group_folders, "BN1: Folder  1: Tutorial", function()
    setups.folder_edit_buttons({
        {A=true};
        {R=true};
        {R=true};
        {Down=true};
        {Down=true};
        {A=true};
        {L=true};
        {Up=true};
        {A=true};
        {L=true};
        {Down=true};
        {A=true};
        {A=true};
        {Up=true};
        {A=true};
        {A=true};
        {R=true};
        {R=true};
        {R=true};
        {Up=true};
        {Up=true};
        {Up=true};
        {A=true};
        {Down=true};
        {A=true};
        {Up=true};
        {Up=true};
        {A=true};
        {L=true};
        {A=true};
        {Down=true};
        {A=true};
        {L=true};
        {Down=true};
        {A=true};
        {R=true};
        {Down=true};
        {Down=true};
        {A=true};
        {A=true};
        {R=true};
        {A=true};
        {R=true};
        {Down=true};
        {A=true};
        {L=true};
        {A=true};
    });
end);

return setups.groups;

