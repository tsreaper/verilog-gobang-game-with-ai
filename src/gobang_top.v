`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Top module
//------------------------------------------------------------------------------
module gobang_top(
    input wire clk,         // Clock (100MHz)
    input wire rst,         // Reset button, 0 = pressed, 1 = released
    input wire ps2_clk,     // PS2 clock
    input wire ps2_data,    // PS2 data
    output wire sync_h,     // VGA horizontal sync
    output wire sync_v,     // VGA vertical sync
    output wire [3:0] r,    // VGA red component
    output wire [3:0] g,    // VGA green component
    output wire [3:0] b,    // VGA blue component
    output wire buz         // Arduino buzzer
    );
    
    wire [3:0] consider_i, consider_j, cursor_i, cursor_j;
    wire data_clr, data_write;
    wire black_is_player, white_is_player, crt_player, game_running;
    wire [1:0] winner;
    
    wire [8:0] black_i, black_j, black_ij, black_ji,
               white_i, white_j, white_ij, white_ji;
    wire [14:0] logic_row, display_black, display_white;
    
    wire key_up, key_down, key_left, key_right, key_ok, key_switch;
    
    wire [3:0] display_i;
    
    wire [31:0] rand_num;
    wire [31:0] clk_div;
    
    // Turn off the arduino buzzer
    assign buz = 1'b1;
    
    gobang_logic
        game_logic(
            .clk_slow(clk_div[16]),
            .clk_fast(clk_div[6]),
            .rst(rst),
            .random(rand_num[0]),
            .key_up(key_up),
            .key_down(key_down),
            .key_left(key_left),
            .key_right(key_right),
            .key_ok(key_ok),
            .key_switch(key_switch),
            .black_i(black_i),
            .black_j(black_j),
            .black_ij(black_ij),
            .black_ji(black_ji),
            .white_i(white_i),
            .white_j(white_j),
            .white_ij(white_ij),
            .white_ji(white_ji),
            .chess_row(logic_row),
            .consider_i(consider_i),
            .consider_j(consider_j),
            .data_clr(data_clr),
            .data_write(data_write),
            .cursor_i(cursor_i),
            .cursor_j(cursor_j),
            .black_is_player(black_is_player),
            .white_is_player(white_is_player),
            .crt_player(crt_player),
            .game_running(game_running),
            .winner(winner)
        );
    
    gobang_datapath
        data(
            .clk(clk_div[16]),
            .rst(rst),
            .clr(data_clr),
            .write(data_write),
            .write_i(cursor_i),
            .write_j(cursor_j),
            .write_color(crt_player),
            .logic_i(cursor_i),
            .display_i(display_i),
            .consider_i(consider_i),
            .consider_j(consider_j),
            .logic_row(logic_row),
            .display_black(display_black),
            .display_white(display_white),
            .black_i(black_i),
            .black_j(black_j),
            .black_ij(black_ij),
            .black_ji(black_ji),
            .white_i(white_i),
            .white_j(white_j),
            .white_ij(white_ij),
            .white_ji(white_ji)
        );
    
    ps2_input
        keyboard(
            .clk_slow(clk_div[16]),
            .clk_fast(clk_div[6]),
            .rst(rst),
            .ps2_clk(ps2_clk),
            .ps2_data(ps2_data),
            .key_up(key_up),
            .key_down(key_down),
            .key_left(key_left),
            .key_right(key_right),
            .key_ok(key_ok),
            .key_switch(key_switch)
        );
    
    vga_display
        display(
            .clk(clk_div[1]),
            .rst(rst),
            .cursor_i(cursor_i),
            .cursor_j(cursor_j),
            .black_is_player(black_is_player),
            .white_is_player(white_is_player),
            .crt_player(crt_player),
            .game_running(game_running),
            .winner(winner),
            .display_black(display_black),
            .display_white(display_white),
            .display_i(display_i),
            .sync_h(sync_h),
            .sync_v(sync_v),
            .r(r),
            .g(g),
            .b(b)
        );
    
    random_generator
        rand(
            .clk(clk_div[6]),
            .rst(rst),
            .load(key_ok),
            .seed(clk_div),
            .rand_num(rand_num)
        );
    
    clk_divider
        divider(
            .clk(clk),
            .rst(rst),
            .clk_div(clk_div)
        );
    
endmodule
