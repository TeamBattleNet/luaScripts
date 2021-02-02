-- HUD Script for Mega Man Battle Network 1, enjoy.

-- To use: Hold L and R, then press:
-- Start to turn HUD on/off
-- Select to Command Mode on/off
-- Left/Right/Up/Down to navigate Commands
-- B to activate the Command Option

-- https://docs.google.com/spreadsheets/d/e/2PACX-1vT5JrlG2InVHk4Rxpz_o3wQ5xbpNj2_n87wY0R99StH9F5P5Cp8AFyjsEQCG6MVEaEMn9dJND-k5M-P/pubhtml Did you check the notes?

local hud = {};
hud.minor_version = "1.2";

local game = require("BN1/Game");
local commands = require("BN1/Commands");

---------------------------------------- Support Functions ----------------------------------------

local options = {};

local show_HUD = true;
local routing_mode = false;
local command_mode = false;

local current_state = nil;
local previous_state = nil;
local state_changed = false;

local keys_held = {};
local keys_previous = {};
local keys_down = {};

local buttons_held = {};
local buttons_previous = {};
local buttons_down = {};

local buttons_ignore = {};
local buttons_string = "";

local function record_menu_buttons()
    if game.in_menu() then
        if game.game_state_changed() then
            buttons_string = "";
        end
        
        if buttons_down.Up then
            buttons_string = buttons_string .. " ^"; -- ↑ ▲
        end
        
        if buttons_down.Down then
            buttons_string = buttons_string .. " v"; -- ↓ ▼
        end
        
        if buttons_down.Left then
            buttons_string = buttons_string .. " >"; -- ← ◄
        end
        
        if buttons_down.Right then
            buttons_string = buttons_string .. " <"; -- → ►
        end
        
        if buttons_down.Start then
            buttons_string = buttons_string .. " S";
        end
        
        if buttons_down.Select then
            buttons_string = buttons_string .. " s";
        end
        
        if buttons_down.B then
            buttons_string = buttons_string .. " B";
        end
        
        if buttons_down.A then
            buttons_string = buttons_string .. " A";
        end
        
        if buttons_down.L then
            buttons_string = buttons_string .. " L";
        end
        
        if buttons_down.R then
            buttons_string = buttons_string .. " R";
        end
    end
end

local function process_inputs()
    buttons_held = joypad.get(); -- controller only
    buttons_down.Up     = (buttons_held.Up     and not buttons_previous.Up    );
    buttons_down.Down   = (buttons_held.Down   and not buttons_previous.Down  );
    buttons_down.Left   = (buttons_held.Left   and not buttons_previous.Left  );
    buttons_down.Right  = (buttons_held.Right  and not buttons_previous.Right );
    buttons_down.Start  = (buttons_held.Start  and not buttons_previous.Start );
    buttons_down.Select = (buttons_held.Select and not buttons_previous.Select);
    buttons_down.B      = (buttons_held.B      and not buttons_previous.B     );
    buttons_down.A      = (buttons_held.A      and not buttons_previous.A     );
    buttons_down.L      = (buttons_held.L      and not buttons_previous.L     );
    buttons_down.R      = (buttons_held.R      and not buttons_previous.R     );
    buttons_previous = buttons_held;
    
    record_menu_buttons(); -- for folder edits
    
    keys_held = input.get(); -- controller, keyboard, and mouse
    keys_down.Up           = (keys_held.Up           and not keys_previous.Up          );
    keys_down.Down         = (keys_held.Down         and not keys_previous.Down        );
    keys_down.Left         = (keys_held.Left         and not keys_previous.Left        );
    keys_down.Right        = (keys_held.Right        and not keys_previous.Right       );
    keys_down.Keypad0      = (keys_held.Keypad0      and not keys_previous.Keypad0     );
    keys_down.KeypadPeriod = (keys_held.KeypadPeriod and not keys_previous.KeypadPeriod);
    keys_previous = keys_held;
end

---------------------------------------- Display Functions ----------------------------------------

local x = 0; -- font is positioned as if 10 pixels by 13 pixels
local y = 0; -- letters can be as wide as 14, or as tall as 17
local anchor = ""; -- one of the four corners

local function to_screen(text, color)
    color = color or 0xFFFFFFFF;
    gui.text(x, y, text, color, anchor);
    y = y + 16;
end

local function position_top_left()
    if     game.in_battle() then     -- align with HP
        x =  0;
        y = 64;
    elseif game.in_world() and game.in_real_world() then -- aligned with PET
        x = 10;
        y = 96;
    else
        x = 5;
        y = 8;
    end
    anchor = "topleft";
end

local function position_bottom_right()
    x = 3;
    y = 3;
    anchor = "bottomright";
end

local function display_RNG(and_value)
    if and_value then
        to_screen("RNG Value: "   .. string.format("%08X", game.get_RNG_value()));
    end
    to_screen(string.format("RNG Index: %4s", (game.get_RNG_index() or "?")));
    to_screen(string.format("RNG Delta: %4s", (game.get_RNG_delta() or "?")));
end

local function display_steps()
    if game.in_digital_world() then
        to_screen(string.format("Steps : %7u", game.get_steps()));
        to_screen(string.format("Check : %7u", game.get_check()));
        to_screen(string.format("Checks: %7u", game.get_encounter_checks()));
        to_screen(string.format("Chance: %6.3f%%", game.get_encounter_chance()));
        to_screen(string.format("Next  : %7i", (64 - (game.get_steps() - game.get_check()))));
    end
    to_screen(string.format("X: %7i", game.get_X()));
    to_screen(string.format("Y: %7i", game.get_Y()));
end

local function display_draws(how_many, start_at)
    start_at = start_at or 1;
    for i=1,how_many do
        to_screen(string.format("%2i: %2i", i+start_at-1, game.get_draw_slot(i+start_at-1)));
    end
end

local function display_in_menu()
    to_screen("TODO: Menu HUD");
end

local function display_player_info()
    to_screen(string.format("Zenny  : %6u", game.get_zenny()));
    to_screen(string.format("Max  HP: %6u", game.calculate_max_HP()));
    to_screen(string.format("Level  : %6u", game.calculate_mega_level()));
    to_screen(string.format("Library: %6u", game.get_library_count()));
end

local function display_game_info()
    to_screen(string.format("Progress: 0x%02X %s", game.get_progress(), game.get_current_progress_name()));
    to_screen("Game Version: " .. game.get_version_name());
    to_screen("HUD  Version: " .. hud.version);
end

local function display_routing()
    position_top_left();
    x = 240;
    y =  16;
    to_screen("0000: " .. game.get_string_binary(0x02000000, 5, true));
    to_screen("0005: " .. game.get_string_binary(0x02000005, 5, true));
    to_screen("000A: " .. game.get_string_binary(0x0200000A, 5, true));
    to_screen("000F: " .. game.get_string_binary(0x0200000F, 5, true));
    to_screen("0000: " .. game.get_string_hex(0x02000000, 16, true));
    to_screen("0010: " .. game.get_string_hex(0x02000010, 16, true));
    to_screen("01FC: " .. game.get_string_hex(0x020001FC, 8, true));
    x = 550;
    y = 112;
    to_screen(game.get_string_binary(0x0200001D, 1, true));
    x = 650;
    y = 112;
    to_screen(tostring(game.is_go_mode()));
end

local function display_commands()
    position_top_left();
    x = 230;
    y = 16+128;
    options = commands.display_options();
    for i=1,table.getn(options) do
        to_screen(options[i]);
    end
end

local function display_HUD()
    position_top_left();
    if game.in_title() or game.in_splash() then
        display_game_info();
        to_screen("");
        display_player_info()
        position_bottom_right();
        to_screen(game.get_current_area_name());
    elseif game.in_world() then
        display_RNG();
        display_steps();
        if game.near_number_doors() then
            to_screen("Door Code: " .. game.get_door_code());
        end
        position_bottom_right();
        to_screen(game.get_current_area_name());
    elseif game.in_battle() or game.in_game_over() then
        display_draws(10);
        position_top_left();
        x = x + 71;
        to_screen(string.format("Battle ID:   0x%4X", game.get_battle_pointer()));
        display_RNG(true);
        to_screen("");
        to_screen(string.format("Checks: %2u", game.get_encounter_checks()));
        position_bottom_right();
        to_screen(game.get_enemy_name(1));
        to_screen(game.get_enemy_name(2));
        to_screen(game.get_enemy_name(3));
    elseif game.in_transition() then
        to_screen("HUD Version: " .. hud.version);
    elseif game.in_menu() or game.in_shop() or game.in_chip_trader() then
        display_in_menu();
    elseif game.in_credits() then
        position_bottom_right();
        to_screen("t r o u t", 0x10000000);
    else
        to_screen("Unknown Game State!");
    end
    
    if command_mode then
        display_commands();
    end
    
    if routing_mode then
        display_routing();
    end
end

---------------------------------------- Module Controls ----------------------------------------

function hud.initialize(options)
    print("Initializing HUD for MMBN 1...");
    hud.version = options.major_version .. "." .. hud.minor_version;
    options.maximum_RNG_index = 10 * 60 * 60; -- 10 minutes of frames
    game.initialize(options);
    print("HUD for MMBN 1 " .. game.get_version_name() .. " Initialized.");
end

function hud.update()
    process_inputs();
    
    options = {};
    game.update_pre(options);
    
    if buttons_held.L and buttons_held.R then
        if buttons_down.Start then
            show_HUD = not show_HUD;
        end
    end
    
    if show_HUD then
        if command_mode then
            if     buttons_down.Select or keys_down.KeypadPeriod then
                command_mode = not command_mode;
            elseif buttons_down.Right  or keys_down.Right   then
                commands.next();
            elseif buttons_down.Left   or keys_down.Left    then
                commands.previous();
            elseif buttons_down.Up     or keys_down.Up      then
                commands.option_up();
            elseif buttons_down.Down   or keys_down.Down    then
                commands.option_down();
            elseif buttons_down.B      or keys_down.Keypad0 then
                commands.doit();
            end
        else
            if buttons_held.L and buttons_held.R then
                if     buttons_down.Select then
                    command_mode = not command_mode;
                elseif buttons_down.Right  then
                    routing_mode = not routing_mode;
                elseif buttons_down.Left   then
                    routing_mode = not routing_mode;
                elseif buttons_down.Up     then
                    -- nothing
                elseif buttons_down.Down   then
                    -- nothing
                elseif buttons_down.B      then
                    -- nothing
                elseif buttons_down.A      then
                    --print(game.get_draw_slots());
                    --print(buttons_held);
                    --print(keys_held);
                    print((string.len(buttons_string)/2) .. " Buttons: " .. buttons_string);
                end
            end
        end
        
        display_HUD();
    end
    
    game.update_post(options);
end

return hud;

