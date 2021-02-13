-- Functions for MMBN 3 scripting, enjoy.

local game = require("All/Game");

game.number = 3;

game.ram      = require("BN3/RAM"     );
game.areas    = require("BN3/Areas"   );
game.chips    = require("BN3/Chips"   );
game.enemies  = require("BN3/Enemies" );
game.progress = require("BN3/Progress");

game.fun_flags = {}; -- set in Commands, used in RAM

---------------------------------------- Game State ----------------------------------------

-- Game Mode

game.game_state_names[0x00] = "Title";         -- or BIOS
game.game_state_names[0x04] = "World";         -- real and digital
game.game_state_names[0x08] = "Battle";
game.game_state_names[0x0C] = "Player Change"; -- jack-in / out
game.game_state_names[0x10] = "Demo End";      -- what is this?
game.game_state_names[0x14] = "Capcom Logo";
game.game_state_names[0x18] = "Menu";
game.game_state_names[0x1C] = "Shop";
game.game_state_names[0x20] = "GAME OVER";
game.game_state_names[0x24] = "Chip Trader";
game.game_state_names[0x28] = "Request Board";
game.game_state_names[0x2C] = "Loading NaviCust?"; -- new?
game.game_state_names[0x30] = "Credits";
game.game_state_names[0x34] = "Unused?";

function game.in_title()
    return game.ram.get.game_state() == 0x00;
end

function game.in_world()
    return game.ram.get.game_state() == 0x04;
end

function game.in_battle()
    return game.ram.get.game_state() == 0x08;
end

function game.in_transition()
    return game.ram.get.game_state() == 0x0C;
end

function game.in_splash()
    return game.ram.get.game_state() == 0x14;
end

function game.in_menu()
    return game.ram.get.game_state() == 0x18;
end

function game.in_shop()
    return game.ram.get.game_state() == 0x1C;
end

function game.in_game_over()
    return game.ram.get.game_state() == 0x20;
end

function game.in_chip_trader()
    return game.ram.get.game_state() == 0x24;
end

function game.in_request_board()
    return game.ram.get.game_state() == 0x28;
end

function game.in_credits()
    return game.ram.get.game_state() == 0x30;
end

-- Battle Mode

game.battle_mode_names[0x00] = "Loading";
game.battle_mode_names[0x03] = "Chip Select & Reward";
game.battle_mode_names[0x12] = "Loading";
game.battle_mode_names[0x13] = "First Chip Select";
game.battle_mode_names[0xCF] = "Time Stop";
game.battle_mode_names[0xEF] = "Combat";

function game.in_chip_select()
    return (game.ram.get.battle_mode() == 0x03 or game.ram.get.battle_mode() == 0x13);
end

function game.in_combat()
    return (game.ram.get.battle_mode() == 0xCF or game.ram.get.battle_mode() == 0xEF);
end

-- Battle State

game.battle_state_names[0x00] = "Waiting";
game.battle_state_names[0x02] = "Time Stop";
game.battle_state_names[0x03] = "Time Stop Name";
game.battle_state_names[0x41] = "ENEMY DELETED!";
game.battle_state_names[0x42] = "Combat";
game.battle_state_names[0x43] = "BATTLE START!";
game.battle_state_names[0x4A] = "PAUSE";

-- Menu Mode

game.menu_mode_names[0x00] = "Folder Select";
game.menu_mode_names[0x04] = "Sub Chips";
game.menu_mode_names[0x08] = "Library";
game.menu_mode_names[0x0C] = "MegaMan";
game.menu_mode_names[0x10] = "E-Mail";
game.menu_mode_names[0x14] = "Key Items";
game.menu_mode_names[0x18] = "Network";
game.menu_mode_names[0x1C] = "Save";
game.menu_mode_names[0x20] = "NaviCust";
game.menu_mode_names[0x24] = "Folder Edit";

function game.in_menu_folder_select()
    return game.ram.get.menu_mode() == 0x00;
end

function game.in_menu_subchips()
    return game.ram.get.menu_mode() == 0x04;
end

function game.in_menu_library()
    return game.ram.get.menu_mode() == 0x08;
end

function game.in_menu_megaman()
    return game.ram.get.menu_mode() == 0x0C;
end

function game.in_menu_email()
    return game.ram.get.menu_mode() == 0x10;
end

function game.in_menu_keyitems()
    return game.ram.get.menu_mode() == 0x14;
end

function game.in_menu_network()
    return game.ram.get.menu_mode() == 0x18;
end

function game.in_menu_save()
    return game.ram.get.menu_mode() == 0x1C;
end

function game.in_menu_navicust()
    return game.ram.get.menu_mode() == 0x20;
end

function game.in_menu_folder_edit()
    return game.ram.get.menu_mode() == 0x24;
end

function game.in_menu_folder()
    return (game.in_menu_folder_select() or game.in_menu_folder_edit());
end

-- Menu State

game.menu_state_names[0x04] = "Editing Folder";
game.menu_state_names[0x08] = "Editing Pack";
game.menu_state_names[0x0C] = "Exiting";
game.menu_state_names[0x10] = "To Folder";
game.menu_state_names[0x14] = "To Pack";
game.menu_state_names[0x18] = "Sorting Folder";
game.menu_state_names[0x1C] = "Sorting Pack";

function game.in_folder()
    return game.in_menu_folder_edit() and (game.ram.get.menu_state() == 0x04 or game.ram.get.menu_state() == 0x18);
end

function game.in_pack()
    return game.in_menu_folder_edit() and (game.ram.get.menu_state() == 0x08 or game.ram.get.menu_state() == 0x1C);
end

----------------------------------------Mega Modifications ----------------------------------------

--[[

function game.get_style_type()
    return bit.rshift(bit.band(memory.read_u8(style_stored), 0x38), 3);
end

function game.get_current_element()
    return bit.band(memory.read_u8(style_stored), 0x07);
end

function game.get_style_name()
    return ram.get_current_element_name() .. ram.get_style_type_name();
end

function game.get_next_element()
    return memory.read_u8(next_element);
end

function game.get_next_element_name()
    return style_elements[ram.get_next_element()] or "????";
end

function game.set_next_element(new_next_element)
    return memory.write_u8(next_element, bit.band(new_next_element, 0x07));
end

function game.get_battle_count()
    return memory.read_u8(battle_count);
end

function game.set_battle_count(new_battle_count)
    return memory.write_u8(battleCount, new_battle_count);
end

function game.add_battle_count(some_battles)
    return ram.set_battle_count(ram.get_battle_count() + some_battles);
end

--]]

---------------------------------------- Flags ----------------------------------------

function game.get_fire_flags()
    return game.ram.get.fire_flags();
end

function game.set_fire_flags(fire_flags)
    game.ram.set.fire_flags(fire_flags);
end

function game.get_magic_byte()
    return 0x00; -- game.ram.get.magic_byte();
end

function game.is_go_mode()
    return false; -- (game.ram.get.progress() == 0x47 and bit.band(game.get_magic_byte(), 0x04) > 0);
end

---------------------------------------- Draw Slots ----------------------------------------

function game.shuffle_folder_simulate_from_battle(offset)
    local lazy_RNG_index = game.get_lazy_RNG_index();
    if lazy_RNG_index ~= nil then
        offset = offset or 0;
        return game.shuffle_folder_simulate_from_lazy_index(lazy_RNG_index-60+1+offset, 30);
    end
end

---------------------------------------- Battlechips ----------------------------------------

function game.count_library()
    local count = 0;
    for i=0,0x1F do -- TODO: determine total bytes
        count = count + game.bit_counter(game.ram.get.library(i));
    end
    return count;
end

function game.overwrite_folder_press_a()
    game.overwrite_folder_to(1, {
        -- TODO
    });
end

---------------------------------------- Miscellaneous ----------------------------------------

function game.set_GMD_RNG(new_GMD_RNG)
    game.ram.set.GMD_RNG(new_GMD_RNG);
end

function game.randomize_GMD_RNG()
    game.set_GMD_RNG(game.get_main_RNG_value());
end

function game.get_gamble_pick()
    return game.ram.get.gamble_pick();
end

function game.get_gamble_win()
    return game.ram.get.gamble_win();
end

function game.is_gambling()
    return game.get_main_area() == 0x8C and -- Sub Comps
          (game.get_sub_area() == 0x02 or   -- Vending Comp (SciLab)
           game.get_sub_area() == 0x08 or   -- TV Board Comp
           game.get_sub_area() == 0x0C );   -- Vending Comp (Hospital)
end

function game.in_Secret_3()
    return (game.get_main_area() == 0x95 and game.get_sub_area() == 0x02);
end

function game.title_screen_A()
    if game.did_leave_title_screen() then
        local RNG_index = game.get_main_RNG_index() or "?????";
        local message = string.format("\n%u: Pressed A on M RNG Index %s", emu.framecount()-17, RNG_index);
        print(message);
        gui.addmessage(message);
    end
end

function game.use_fun_flags(fun_flags)
    if fun_flags.randomize_colors then
        --if game.did_game_state_change() or game.did_menu_mode_change() or game.did_area_change() then game.doit_later[emu.framecount()+3] = game.randomize_color_palette; end
    end
end

---------------------------------------- Module Controls ----------------------------------------

local settings = require("All/Settings");

function game.initialize(options)
    settings.set_display_text("gui"); -- TODO: Remove when gui.text fully supported
    game.ram.initialize(options);
end

function game.pre_update(options)
    game.title_screen_A();
    options.fun_flags = game.fun_flags;
    game.ram.pre_update(options);
    game.use_fun_flags(game.fun_flags);
end

function game.post_update(options)
    game.track_game_state();
    game.ram.post_update(options);
end

return game;

