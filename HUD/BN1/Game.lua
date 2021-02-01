-- Functions for MMBN 1 Scripting, enjoy.

local game = {};

game.ram      = require("BN1/RAM"     );
game.areas    = require("BN1/Areas"   );
game.chips    = require("BN1/Chips"   );
game.enemies  = require("BN1/Enemies" );
game.progress = require("BN1/Progress");
game.rng      = require("BN1/RNG"     );

---------------------------------------- RNG Wrapper ----------------------------------------

function game.get_RNG_value()
    return game.rng.get_RNG_value();
end

function game.set_RNG_value(new_rng)
    game.rng.set_RNG_value(new_rng);
end

function game.get_RNG_index()
    return game.rng.get_RNG_index();
end

function game.set_RNG_index(new_index)
    game.rng.set_RNG_index(new_index)
end

function game.get_RNG_delta()
    return game.rng.get_RNG_delta();
end

function game.adjust_RNG(steps)
    game.rng.adjust_RNG(steps);
end

---------------------------------------- Game State ----------------------------------------

function game.get_version_byte()
    return game.ram.version_byte;
end

function game.get_version_name()
    return game.ram.version_name;
end

function game.get_play_time()
    return game.ram.get.play_time();
end

function game.set_play_time(new_play_time)
    game.ram.set.play_time(new_play_time);
end

game.game_state_names       = {};
game.game_state_names[0x00] = "title";         -- or BIOS
game.game_state_names[0x04] = "world";         -- real and digital
game.game_state_names[0x08] = "battle";
game.game_state_names[0x0C] = "player_change"; -- jack-in / out
game.game_state_names[0x10] = "demo_end";      -- what is this?
game.game_state_names[0x14] = "capcom_logo";
game.game_state_names[0x18] = "menu";
game.game_state_names[0x1C] = "shop";
game.game_state_names[0x20] = "game_over";
game.game_state_names[0x24] = "trader";
game.game_state_names[0x28] = "credits";
game.game_state_names[0x2C] = "ubisoft_logo";  -- PAL only

function game.get_game_state()
    return game.ram.get.game_state();
end

function game.get_game_state_name()
    return game.game_state_names[game.get_game_state()] or "unknown";
end

function game.in_title()
    return game.get_game_state() == 0x00;
end

function game.in_world()
    return game.get_game_state() == 0x04;
end

function game.in_battle()
    return game.get_game_state() == 0x08;
end

function game.in_transition()
    return game.get_game_state() == 0x0C;
end

function game.in_splash()
    return (game.get_game_state() == 0x14 or game.get_game_state() == 0x2C);
end

function game.in_menu()
    return game.get_game_state() == 0x18;
end

function game.in_shop()
    return game.get_game_state() == 0x1C;
end

function game.in_game_over()
  return game.get_game_state() == 0x20;
end

function game.in_chip_trader()
  return game.get_game_state() == 0x24;
end

function game.in_credits()
    return game.get_game_state() == 0x28;
end

---------------------------------------- Progress ----------------------------------------

function game.get_progress()
    return game.ram.get.progress();
end

function game.get_progress_name(progress_value)
    return game.progress[progress_value];
end

function game.get_current_progress_name()
    return game.get_progress_name(game.get_progress());
end

function game.set_progress(new_progress)
    if new_progress < 0x00 then
        new_progress = 0x00;
    elseif new_progress > 0x5F then
        new_progress = 0x5F;
    end
    game.ram.set.progress(new_progress);
end

function game.set_progress_safe(new_progress)
    if game.get_progress_name(new_progress) then
        game.set_progress(new_progress);
    end
end

function game.add_progress(some_progress)
    return game.set_progress(game.get_progress() + some_progress);
end

---------------------------------------- Flags ----------------------------------------

function game.get_fire_flags()
    return game.ram.get.fire_flags();
end

function game.set_fire_flags(fire_flags)
    game.ram.set.fire_flags(fire_flags);
end

function game.ignite_oven_fires()
    game.ram.set.fire_flags     (0x00000000);
    game.ram.set.fire_flags_oven(0x00000000);
end

function game.extinguish_oven_fires() -- TODO: Improve precision
    game.ram.set.fire_flags     (0xFFFFFFFF);
    game.ram.set.fire_flags_oven(0xFFFFFFFF);
end

function game.ignite_WWW_fires()
    game.ram.set.fire_flags    (0x00000000);
    game.ram.set.fire_flags_www(0x00000000);
end

function game.extinguish_WWW_fires()
    game.ram.set.fire_flags    (0x00FEFFFF);
    game.ram.set.fire_flags_www(0xFCFFFF01);
end

function game.get_star_byte()
    return game.ram.get.title_star_byte();
end

function game.set_star_byte(new_star_byte)
    game.ram.set.title_star_byte(new_star_byte);
end

function game.get_star_flag()
    return bit.rshift(bit.band(game.get_star_byte(), 0x04), 2);
end

function game.set_star_flag()
    game.set_star_byte(bit.bor(game.get_star_byte(), 0x04));
end

function game.clear_star_flag()
    game.set_star_byte(bit.band(game.get_star_byte(), 0xFB));
end

function game.get_magic_byte()
    return game.ram.get.magic_byte();
end

function game.set_magic_byte(new_magic)
    game.ram.set.magic_byte(new_magic);
end

function game.is_magic_bit_set()
    return bit.band(game.get_magic_byte(), 0x18) == 0x10;
end

function game.is_go_mode()
    return game.is_magic_bit_set() and (game.get_progress() == 0x54);
end

function game.go_mode()
    game.set_progress(0x54);
    game.set_magic_byte(0x10);
end

---------------------------------------- Position ----------------------------------------

function game.get_main_area()
    return game.ram.get.main_area();
end

function game.set_main_area(new_main_area)
    game.ram.set.main_area(new_main_area);
end

function game.get_sub_area()
    return game.ram.get.sub_area();
end

function game.set_sub_area(new_sub_area)
    game.ram.set.sub_area(new_sub_area);
end

function game.teleport(new_main_area, new_sub_area)
    game.set_main_area(new_main_area);
    game.set_sub_area(new_sub_area);
end

function game.get_area_name(main_area, sub_area)
    if game.areas.names[main_area] then
        if game.areas.names[main_area][sub_area] then
            return game.areas.names[main_area][sub_area];
        end
        return "Unknown Sub Area";
    end
    return "Unknown Main Area";
end

function game.get_current_area_name()
    return game.get_area_name(game.get_main_area(), game.get_sub_area());
end

function game.does_area_exist(main_area, sub_area)
    return game.areas.names[main_area] and game.areas.names[main_area][sub_area];
end

function game.get_area_groups_real()
    return game.areas.real_groups;
end

function game.get_area_groups_digital()
    return game.areas.digital_groups;
end

function game.get_area_group_name(main_area)
    return game.areas.names[main_area].group;
end

function game.in_real_world()
    if game.get_main_area() < 0x80 then
        return true;
    end
    return false;
end

function game.in_digital_world()
    return not game.in_real_world();
end

function game.get_X()
    return game.ram.get.your_X();
end

function game.get_Y()
    return game.ram.get.your_Y();
end

function game.get_steps()
    return game.ram.get.steps();
end

function game.set_steps(new_steps)
    if new_steps < 0 then
        new_steps = 0
    elseif new_steps > 0xFFFF then
        new_steps = 0xFFFF;
    end
    game.ram.set.steps(new_steps);
end

function game.add_steps(some_steps)
    game.set_steps(game.get_steps() + some_steps);
end

function game.get_check()
    return game.ram.get.check();
end

function game.set_check(new_check)
    if new_check < 0 then
        new_check = 0
    elseif new_check > 0xFFFF then
        new_check = 0xFFFF;
    end
    game.ram.set.check(new_check);
end

function game.add_check(some_check)
    game.set_check(game.get_check() + some_check);
end

---------------------------------------- Inventory ----------------------------------------

function game.get_zenny()
    return game.ram.get.zenny();
end

function game.set_zenny(new_zenny)
    if new_zenny < 0 then
        new_zenny = 0
    elseif new_zenny > 999999 then
        new_zenny = 999999;
    end
    game.ram.set.zenny(new_zenny);
end

function game.add_zenny(some_zenny)
    game.set_zenny(game.get_zenny() + some_zenny);
end

function game.get_PowerUPs()
    return game.ram.get.PowerUP();
end

function game.set_PowerUPs(new_PowerUPs)
    if new_PowerUPs < 0 then
        new_PowerUPs = 0
    elseif new_PowerUPs > 50 then
        new_PowerUPs = 50;
    end
    game.ram.set.PowerUP(new_PowerUPs);
end

function game.add_PowerUPs(some_PowerUPs)
    game.set_PowerUPs(game.get_PowerUPs() + some_PowerUPs);
end

function game.get_IceBlocks()
    return game.ram.get.IceBlock();
end

function game.set_IceBlocks(new_IceBlocks)
    if new_IceBlocks < 0 then
        new_IceBlocks = 0
    elseif new_IceBlocks > 53 then
        new_IceBlocks = 53;
    end
    game.ram.set.IceBlock(new_IceBlocks);
end

function game.add_IceBlocks(some_IceBlocks)
    game.set_IceBlocks(game.get_IceBlocks() + some_IceBlocks);
end

---------------------------------------- Battlechips ----------------------------------------

function game.get_chip_name(ID)
    return game.chips.names[ID];
end

function game.get_chip_code(code)
    return game.chips.codes[code];
end

function game.get_battlechip_count()
    -- TODO
end

function game.get_library_count()
    -- TODO
end

----------------------------------------Mega Modifications ----------------------------------------

function game.set_buster_stats(power_level)
    game.ram.set.buster_attack(power_level);
    game.ram.set.buster_rapid (power_level);
    game.ram.set.buster_charge(power_level);
end

function game.reset_buster_stats()
    game.set_buster_stats(0); -- 0 indexed
end

function game.max_buster_stats()
    game.set_buster_stats(4);
end

function game.hub_buster_stats()
    game.set_buster_stats(5); -- super armor
end

function game.op_buster_stats()
    game.set_buster_stats(7); -- 327 buster shots
end

----------------------------------------Battle Information ----------------------------------------

function game.get_battle_pointer()
    return game.ram.get.battle_pointer();
end

function game.get_enemy_ID(which_enemy)
    return game.ram.get.enemy[which_enemy].ID();
end

function game.get_enemy_name(which_enemy)
    return game.enemies.names[game.get_enemy_ID(which_enemy)];
end

function game.get_enemy_HP(which_enemy)
    return game.ram.get.enemy[which_enemy].HP();
end

function game.set_enemy_HP(which_enemy, new_HP)
    game.ram.set.enemy[which_enemy].HP(new_HP);
end

function game.kill_enemy(which_enemy)
    if which_enemy == 0 then
        game.set_enemy_HP(1, 0);
        game.set_enemy_HP(2, 0);
        game.set_enemy_HP(3, 0);
    else
        game.set_enemy_HP(which_enemy, 0);
    end
end

function game.get_custom_gauge()
    return game.ram.get.custom_gauge();
end

function game.set_custom_gauge(new_custom_gauge)
    if new_custom_gauge < 0 then
        new_custom_gauge = 0;
    elseif new_custom_gauge > 0x4000 then
        new_custom_gauge = 0x4000;
    end
    game.ram.set.custom_gauge(new_custom_gauge);
end

function game.empty_custom_gauge()
    game.set_custom_gauge(0x0000);
end

function game.fill_custom_gauge()
    game.set_custom_gauge(0x4000);
end

function game.get_delete_timer()
    return game.ram.get.delete_timer();
end

function game.set_delete_timer(new_delete_timer)
    if new_delete_timer < 0 then
        new_delete_timer = 0;
    end
    game.ram.set.delete_timer(new_delete_timer);
end

function game.reset_delete_timer()
    game.set_delete_timer(0);
end

function game.get_draw_slot(which_slot)
    if 1 <= which_slot and which_slot <= 30 then
        return game.ram.get.draw_slot(which_slot-1) + 1; -- convert from 1 to 0 index, then back
    end
    return -1;
end

function game.get_draw_slots()
    slots = {};
    for i=1,30 do
        slots[i] = game.get_draw_slot(i);
    end
    return slots;
end

---------------------------------------- Miscellaneous ----------------------------------------

function game.get_door_code()
    return game.ram.get.door_code();
end

function game.set_door_code(new_door_code)
    game.ram.set.door_code(new_door_code);
end

function game.near_number_doors() -- School Comps or WWW Comp 2
    return game.get_main_area() == 0x80 or (game.get_main_area() == 0x85 and game.get_sub_area() == 0x01);
end

---------------------------------------- Routing ----------------------------------------

function game.get_bit(byte, bindex) -- 0 indexed
    return bit.rshift( bit.band( byte, bit.lshift( 0x01, bindex ) ), bindex );
end

function game.get_string_binary(address, bytes, with_spaces)
    if address and bytes then
        local binary = "";
        for i=0,bytes-1 do
            local byte = memory.read_u8(address+i);
            for i=0,7 do
                binary = binary .. tostring(game.get_bit(byte, 7-i));
                if i==3 and with_spaces then
                    binary = binary .. " ";
                end
            end
            if with_spaces then
                binary = binary .. " ";
            end
        end
        return binary;
    end
end

function game.get_string_hex(address, bytes, with_spaces)
    if address and bytes then
        local hex = "";
        local format = "%02X";
        if with_spaces then
            format = format .. " ";
        end
        for i=0,bytes-1 do
            hex = hex .. string.format(format, memory.read_u8(address+i));
        end
        return hex;
    end
end

---------------------------------------- Encounter Tracking and Avoidance ----------------------------------------

local last_encounter_check = 0; -- the previous value of check

function game.get_encounter_checks()
    return math.floor(last_encounter_check / 64); -- approximate
end

function game.get_encounter_threshold()
    local curve_addr = game.ram.addr.encounter_curve;
    local curve_offset = (game.get_main_area() - 0x80) * 0x10 + game.get_sub_area();
    curve = memory.read_u8(curve_addr + curve_offset);
    local odds_addr = game.ram.addr.encounter_odds;
    local test_level = math.min(math.floor(game.get_steps() / 64) + 1, 16);
    return memory.read_u8(odds_addr + test_level * 8 + curve);
end

function game.get_encounter_chance()
    return (game.get_encounter_threshold() / 32) * 100;
end

function game.would_get_encounter()
    return game.get_encounter_threshold() > (game.get_RNG_value() % 0x20);
end

game.skip_encounters = false;

local function encounter_check()
    if game.in_world() then
        if game.get_check() < last_encounter_check then
            last_encounter_check = 0; -- dodged encounter or area (re)load or state load
        elseif game.get_check() > last_encounter_check then
            last_encounter_check = game.get_check();
        end
        
        if game.skip_encounters then
            if game.get_steps() > 64 then
                game.set_steps(game.get_steps() % 64);
                game.set_check(game.get_check() % 64);
            end
        end
    end
end

---------------------------------------- Module Controls ----------------------------------------

function game.initialize(options)
    game.rng.initialize(options.max_RNG_index);
end

function game.update_pre()
    encounter_check();
    game.rng.update_pre();
end

function game.update_post()
    game.rng.update_post();
end

return game;
