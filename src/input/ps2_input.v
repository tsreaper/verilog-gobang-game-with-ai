`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Dealing with the input data of the PS2 keyboard
//------------------------------------------------------------------------------
module ps2_input(
    input wire clk_slow,      // Slower clock for this module
    input wire clk_fast,      // Faster clock for the PS2 scanner
    input wire rst,           // Reset
    input wire ps2_clk,       // PS2 clock
    input wire ps2_data,      // PS2 data
    
    output wire key_up,       // If UP key is pressed
    output wire key_down,     // If DOWN key is pressed
    output wire key_left,     // If LEFT key is pressed
    output wire key_right,    // If RIGHT key is pressed
    output wire key_ok,       // If OK key is pressed
    output wire key_switch    // If SWITCH key is pressed
    );
    
    wire [8:0] crt_data;    // Input data of the PS2 keyboard
    
    // Key state recorders
    reg [1:0] key_up_state, key_down_state, key_left_state,
              key_right_state, key_ok_state, key_switch_state;
    // Only becomes true at the posedge of each key
    assign key_up = key_up_state[0] & ~key_up_state[1];
    assign key_down = key_down_state[0] & ~key_down_state[1];
    assign key_left = key_left_state[0] & ~key_left_state[1];
    assign key_right = key_right_state[0] & ~key_right_state[1];
    assign key_ok = key_ok_state[0] & ~key_ok_state[1];
    assign key_switch = key_switch_state[0] & ~key_switch_state[1];
    
    // PS2 keyboard scanner
    ps2_scan
        scanner(
            .clk(clk_fast),
            .rst(rst),
            .ps2_clk(ps2_clk),
            .ps2_data(ps2_data),
            .crt_data(crt_data)
        );
    
    always @ (posedge clk_slow or negedge rst)
        if (!rst) begin
            key_up_state <= 2'b0;
            key_down_state <= 2'b0;
            key_left_state <= 2'b0;
            key_right_state <= 2'b0;
            key_ok_state <= 2'b0;
            key_switch_state <= 2'b0;
        end
        else begin
            // Record the key state
            key_up_state <= {key_up_state[0], crt_data == 9'h175};
            key_down_state <= {key_down_state[0], crt_data == 9'h172};
            key_left_state <= {key_left_state[0], crt_data == 9'h16b};
            key_right_state <= {key_right_state[0], crt_data == 9'h174};
            key_ok_state <= {key_ok_state[0], crt_data == 9'h029};
            key_switch_state <= {key_switch_state[0], crt_data == 9'h014};
        end

endmodule
