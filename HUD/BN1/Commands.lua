-- Commands for MMBN 1 scripting, enjoy.

local commands = require("All/Commands"); -- Menu, Flags, Battle, Items, RNG, Progress, Real, Digital, Setups

commands.game = require("BN1/Game");
commands.setup_groups = require("BN1/Setups");

for i,command in pairs(commands.general) do
    if command.update_options then
        command.update_options();
    end
end

table.insert(commands.commands, commands.general.command_menu);

---------------------------------------- Flags ----------------------------------------

local function fun_flag_helper(fun_flag, fun_text)
    if commands.game.fun_flags[fun_flag] then
        fun_text = "[ ON] " .. fun_text;
    else
        fun_text = "[off] " .. fun_text;
    end
    return { value = fun_flag; text = fun_text; };
end

local command_fun_flags = {};
command_fun_flags.selection = 1;
command_fun_flags.description = function() return "These Fun Flags Are:"; end;
function command_fun_flags.update_options(option_value)
    command_fun_flags.options = {};
    table.insert( command_fun_flags.options, fun_flag_helper("modulate_steps"     , "Step Modulation"           ) );
    table.insert( command_fun_flags.options, fun_flag_helper("always_fullcust"    , "Always Fullcust"           ) );
    table.insert( command_fun_flags.options, fun_flag_helper("no_chip_cooldown"   , "No Chip Cooldown"          ) );
    table.insert( command_fun_flags.options, fun_flag_helper("delete_time_zero"   , "Set Delete Time to 0"      ) );
    table.insert( command_fun_flags.options, fun_flag_helper("chip_selection_one" , "Always Choose  1 Chip"     ) );
    table.insert( command_fun_flags.options, fun_flag_helper("chip_selection_max" , "Always Choose 15 Chips"    ) );
    table.insert( command_fun_flags.options, fun_flag_helper("no_encounters"      , "Lock RNG to No  Encounters") );
    table.insert( command_fun_flags.options, fun_flag_helper("yes_encounters"     , "Lock RNG to Yes Encounters") );
    table.insert( command_fun_flags.options, fun_flag_helper("is_routing"         , "Display Routing Messages"  ) );
    table.insert( command_fun_flags.options, fun_flag_helper("randomize_colors"   , "Randomize Color Palette"   ) );
end
command_fun_flags.update_options();
function command_fun_flags.doit(value)
    commands.game.fun_flags[value] = not commands.game.fun_flags[value];
    command_fun_flags.update_options();
end
table.insert(commands.commands, command_fun_flags);

---------------------------------------- Battle ----------------------------------------

local command_battle = {};
command_battle.selection = 1;
command_battle.description = function() return "Battle Options:"; end;
command_battle.options = {
    { value = function() commands.game.kill_enemy(0);     end; text = "Delete Everything"     ; };
    { value = function() commands.game.kill_enemy(1);     end; text = "Delete Enemy 1"        ; };
    { value = function() commands.game.kill_enemy(2);     end; text = "Delete Enemy 2"        ; };
    { value = function() commands.game.kill_enemy(3);     end; text = "Delete Enemy 3"        ; };
    { value = function() commands.game.draw_in_order();   end; text = "Draw Slots: In Order"  ; };
    { value = function() commands.game.draw_only_slot(0); end; text = "Draw Slots: All Slot 1"; };
};
command_battle.doit = function(value) value(); end;
table.insert(commands.commands, command_battle);

---------------------------------------- Items ----------------------------------------

local command_items = {};
command_items.sub_selection = 1;
function command_items.update_options(option_value)
    command_items.options = {};
    command_items.FUNction = nil;
    
    if not option_value then
        command_items.selection = command_items.sub_selection;
        command_items.description = function() return "What will U buy?"; end;
        table.insert( command_items.options, { value = 1; text = "Zenny"    ; } );
        table.insert( command_items.options, { value = 2; text = "IceBlock" ; } );
        table.insert( command_items.options, { value = 3; text = "PowerUP"  ; } );
        table.insert( command_items.options, { value = 4; text = "HPMemory" ; } );
        table.insert( command_items.options, { value = 5; text = "Equipment"; } );
        table.insert( command_items.options, { value = 6; text = "Folders"  ; } );
    else
        command_items.sub_selection = command_items.selection;
        command_items.selection = 1;
        table.insert( command_items.options, { value = nil; text = "Previous Menu"; } );
        if option_value == 1 then
            command_items.description = function() return string.format("Zenny: %11u", commands.game.get_zenny()); end;
            table.insert( command_items.options, { value =  100000; text = "Increase by 100000"; } );
            table.insert( command_items.options, { value =   10000; text = "Increase by  10000"; } );
            table.insert( command_items.options, { value =    1000; text = "Increase by   1000"; } );
            table.insert( command_items.options, { value =     100; text = "Increase by    100"; } );
            table.insert( command_items.options, { value =    -100; text = "Decrease by    100"; } );
            table.insert( command_items.options, { value =   -1000; text = "Decrease by   1000"; } );
            table.insert( command_items.options, { value =  -10000; text = "Decrease by  10000"; } );
            table.insert( command_items.options, { value = -100000; text = "Decrease by 100000"; } );
            command_items.FUNction = function(value) commands.game.add_zenny(value); end;
        elseif option_value == 2 then
            command_items.description = function() return string.format("IceBlocks: %2u", commands.game.get_IceBlocks()); end;
            table.insert( command_items.options, { value =  53; text = "Give 53"; } );
            table.insert( command_items.options, { value =   1; text = "Give  1"; } );
            table.insert( command_items.options, { value =  -1; text = "Take  1"; } );
            table.insert( command_items.options, { value = -53; text = "Take 53"; } );
            command_items.FUNction = function(value) commands.game.add_IceBlocks(value); end;
        elseif option_value == 3 then
            command_items.description = function() return string.format("PowerUPs: %2u", commands.game.get_PowerUPs()); end;
            table.insert( command_items.options, { value =  10; text = "Give 10"; } );
            table.insert( command_items.options, { value =   1; text = "Give  1"; } );
            table.insert( command_items.options, { value =  -1; text = "Take  1"; } );
            table.insert( command_items.options, { value = -10; text = "Take 10"; } );
            command_items.FUNction = function(value) commands.game.add_PowerUPs(value); end;
        elseif option_value == 4 then
            command_items.description = function() return string.format("HPMemory: %2u", commands.game.get_HPMemory_count()); end;
            table.insert( command_items.options, { value = nil; text = "Apologies... That is sold out..."; } );
        elseif option_value == 5 then
            command_items.description = function() return string.format("Power Level: %4u", commands.game.calculate_mega_level()); end;
            table.insert( command_items.options, { value = commands.game.reset_buster_stats; text = "Reset Buster Stats"     ; } );
            table.insert( command_items.options, { value = commands.game.max_buster_stats;   text = "Max   Buster Stats"     ; } );
            table.insert( command_items.options, { value = commands.game.hub_buster_stats;   text = "Hub   Buster Stats"     ; } );
            table.insert( command_items.options, { value = commands.game.op_buster_stats;    text = "OP    Buster Stats"     ; } );
            table.insert( command_items.options, { value = commands.game.give_armor;         text = "Get equiped with Armor!"; } );
            command_items.FUNction = function(value) value(); end;
        elseif option_value == 6 then
            command_items.description = function() return "Sponsored by TeamBN"; end;
            table.insert( command_items.options, { value = function() commands.game.set_all_folder_code_to(1,       0); end; text = "Folder: Monocode A Folder"     ; } );
            table.insert( command_items.options, { value = function() commands.game.randomize_folder_codes(1         ); end; text = "Folder: Randomize Folder Codes"; } );
            table.insert( command_items.options, { value = function() commands.game.overwrite_folder_press_a(        ); end; text = "Folder: Just PressA"           ; } );
            table.insert( command_items.options, { value = function() commands.game.overwrite_folder_smog_special(   ); end; text = "Folder: The SmogBN Special"    ; } );
            table.insert( command_items.options, { value = function() commands.game.overwrite_folder_dalus_special(  ); end; text = "Folder: The Dalus_EXE Special" ; } );
            table.insert( command_items.options, { value = function() commands.game.overwrite_folder_chaotic_special(); end; text = "Folder: The ChaoticMK Special" ; } );
            table.insert( command_items.options, { value = function() commands.game.randomize_folder_IDs_standard(1  ); end; text = "Folder: Randomize Folder IDs"  ; } );
            table.insert( command_items.options, { value = function() commands.game.randomize_folder_IDs_anything(1  ); end; text = "Folder: Super Randomize IDs"   ; } );
            command_items.FUNction = function(value) value(); end;
        else
            command_items.description = function() return "Bzzt! (something broke)"; end;
        end
    end
end
command_items.update_options();
function command_items.doit(value)
    if command_items.FUNction and value then
        command_items.FUNction(value);
    else
        command_items.update_options(value);
    end
end
table.insert(commands.commands, command_items);

---------------------------------------- Routing ----------------------------------------

local command_routing = {};
command_routing.sub_selection = 1;
function command_routing.update_options(option_value)
    command_routing.options = {};
    command_routing.FUNction = nil;
    
    if not option_value then
        command_routing.selection = command_routing.sub_selection;
        command_routing.description = function() return "Wanna see some RNG manip?"; end;
        table.insert( command_routing.options, { value = 1; text = "Main RNG Index"; } );
        table.insert( command_routing.options, { value = 2; text = "Step Counter"  ; } );
        table.insert( command_routing.options, { value = 3; text = "Flag Flipper"  ; } );
    else
        command_routing.sub_selection = command_routing.selection;
        command_routing.selection = 1;
        table.insert( command_routing.options, { value = nil; text = "Previous Menu"; } );
        if option_value == 1 then
            command_routing.description = function() return string.format("RNG Index: %5s", (commands.game.get_main_RNG_index() or "?????")); end;
            table.insert( command_routing.options, { value =  1000; text = "Increase by 1000"; } );
            table.insert( command_routing.options, { value =   100; text = "Increase by  100"; } );
            table.insert( command_routing.options, { value =    10; text = "Increase by   10"; } );
            table.insert( command_routing.options, { value =     1; text = "Increase by    1"; } );
            table.insert( command_routing.options, { value =    -1; text = "Decrease by    1"; } );
            table.insert( command_routing.options, { value =   -10; text = "Decrease by   10"; } );
            table.insert( command_routing.options, { value =  -100; text = "Decrease by  100"; } );
            table.insert( command_routing.options, { value = -1000; text = "Decrease by 1000"; } );
            command_routing.FUNction = function(value) commands.game.adjust_main_RNG(value); end;
        elseif option_value == 2 then
            command_routing.description = function() return string.format("Modify Steps: %5s", commands.game.get_steps()); end;
            table.insert( command_routing.options, { value =  1024; text = "Increase by 1024"; } );
            table.insert( command_routing.options, { value =    64; text = "Increase by   64"; } );
            table.insert( command_routing.options, { value =     2; text = "Increase by    2"; } );
            table.insert( command_routing.options, { value =     1; text = "Increase by    1"; } );
            table.insert( command_routing.options, { value =    -1; text = "Decrease by    1"; } );
            table.insert( command_routing.options, { value =    -2; text = "Decrease by    2"; } );
            table.insert( command_routing.options, { value =   -64; text = "Decrease by   64"; } );
            table.insert( command_routing.options, { value = -1024; text = "Decrease by 1024"; } );
            command_routing.FUNction = function(value) commands.game.add_steps(value); end;
        elseif option_value == 3 then
            command_routing.description = function() return "Bits, Nibbles, Bytes, and Words."; end;
            table.insert( command_routing.options, { value = commands.game.go_mode;               text = "Go Mode"              ; } );
            table.insert( command_routing.options, { value = commands.game.set_star_flag;         text = "Set Star Flag"        ; } );
            table.insert( command_routing.options, { value = commands.game.clear_star_flag;       text = "Clear Star Flag"      ; } );
            table.insert( command_routing.options, { value = commands.game.ignite_oven_fires;     text = "Ignite Oven Fires"    ; } );
            table.insert( command_routing.options, { value = commands.game.extinguish_oven_fires; text = "Extinguish Oven Fires"; } );
            table.insert( command_routing.options, { value = commands.game.ignite_WWW_fires;      text = "Ignite WWW Fires"     ; } );
            table.insert( command_routing.options, { value = commands.game.extinguish_WWW_fires;  text = "Extinguish WWW Fires" ; } );
            table.insert( command_routing.options, { value = commands.game.reset_main_RNG;        text = "Restart Main RNG"     ; } );
            command_routing.FUNction = function(value) value(); end;
        else
            command_routing.description = function() return "Bzzt! (something broke)"; end;
        end
    end
end
command_routing.update_options();
function command_routing.doit(value)
    if command_routing.FUNction and value then
        command_routing.FUNction(value);
    else
        command_routing.update_options(value);
    end
end
table.insert(commands.commands, command_routing);

---------------------------------------- Module ----------------------------------------

table.insert(commands.commands, commands.general.command_progress);
table.insert(commands.commands, commands.general.teleport_real_world);
table.insert(commands.commands, commands.general.teleport_digital_world);
table.insert(commands.commands, commands.general.command_setups);

return commands.commands;

