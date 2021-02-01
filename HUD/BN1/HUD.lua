-- HUD Script for Mega Man Battle Network 1, enjoy.

-- To use: Hold L and R, then press:
-- Start to turn HUD on/off
-- Select to Command Mode on/off
-- Left/Right/Up/Down to navigate Commands
-- B to activate the Command Option

-- https://docs.google.com/spreadsheets/d/e/2PACX-1vT5JrlG2InVHk4Rxpz_o3wQ5xbpNj2_n87wY0R99StH9F5P5Cp8AFyjsEQCG6MVEaEMn9dJND-k5M-P/pubhtml Did you check the notes?

local hud = {};
hud.minor_version = "0.0";

local game = require("BN1/Game");
local commands = require("BN1/Commands");

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
    to_screen(string.format("Zenny   : %7u", game.get_zenny()));
    -- TODO: MegaMan Stats
    -- TODO: Library Stats
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
    to_screen("0000: " .. game.get_string_hex(0x02000000, 16, true));
    to_screen("0010: " .. game.get_string_hex(0x02000010, 16, true));
    to_screen("0000: " .. game.get_string_binary(0x02000000, 4, true));
    to_screen("0004: " .. game.get_string_binary(0x02000000, 4, true));
    to_screen("0008: " .. game.get_string_binary(0x02000000, 4, true));
    to_screen("000C: " .. game.get_string_binary(0x02000000, 4, true));
    to_screen("01FC: " .. game.get_string_hex(0x020001FC, 8, true));
    x = 550;
    y = 112;
    to_screen(tostring(game.is_go_mode()));
    x = 600;
    y = 112;
    to_screen(game.get_string_binary(0x0200001D, 1, true));
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

------------------------------------------------------------------------------------------------------------------------

local show_HUD = true;

local routing_mode = false;
local command_mode = false;

local function display_HUD()
    position_top_left();
    if game.in_title() or game.in_splash() then
        display_game_info();
        to_screen("");
        display_RNG(true);
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

function hud.initialize(options)
    print("Initializing HUD for MMBN 1...");
    hud.version = options.major_version .. "." .. hud.minor_version;
    options.max_RNG_index = 10 * 60 * 60; -- 10 minutes of frames
    game.initialize(options);
    print("HUD for MMBN 1 " .. game.get_version_name() .. " Initialized.");
end

local previous_keys = {};
local previous_buttons = {};

function hud.update()
    game.update_pre();
    
    local keys = joypad.get();
    local buttons = input.get();
    
    if keys.L and keys.R then
        if keys.Start and not previous_keys.Start then
            show_HUD = not show_HUD;
        end
    end
    
    if show_HUD then
        if (keys.L and keys.R) or command_mode then
            if     keys.Select and not previous_keys.Select then
                command_mode = not command_mode;
            elseif keys.Right  and not previous_keys.Right  then
                commands.next();
            elseif keys.Left   and not previous_keys.Left   then
                commands.previous();
            elseif keys.Up     and not previous_keys.Up     then
                commands.option_up();
            elseif keys.Down   and not previous_keys.Down   then
                commands.option_down();
            elseif keys.B      and not previous_keys.B      then
                commands.doit();
            elseif keys.A      and not previous_keys.A      then
                --print(game.get_draw_slots());
                --print(buttons);
                --print(keys);
            end
        end
        
        if buttons.Grave and not previous_buttons.Grave then -- Grave is `
            if buttons.Shift then
                routing_mode = not routing_mode;
            else
                command_mode = not command_mode;
            end
        end
        
        if command_mode then
            if     buttons.Right   and not previous_buttons.Right   then
                commands.next();
            elseif buttons.Left    and not previous_buttons.Left    then
                commands.previous();
            elseif buttons.Up      and not previous_buttons.Up      then
                commands.option_up();
            elseif buttons.Down    and not previous_buttons.Down    then
                commands.option_down();
            elseif buttons.Keypad0 and not previous_buttons.Keypad0 then
                commands.doit();
            end
        end
        
        display_HUD();
    end
    
    game.update_post();
    
    previous_keys = keys;
    previous_buttons = buttons;
end

return hud;

