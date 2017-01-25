`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// PS2 keyboard scanner
//------------------------------------------------------------------------------
module ps2_scan(
    input wire clk,              // Clock
    input wire rst,              // Reset
    input wire ps2_clk,          // PS2 clock
    input wire ps2_data,         // PS2 data
    
    output reg [8:0] crt_data    // Input data of the keyboard
    );
    
    reg [1:0] ps2_clk_state;    // PS2 clock recorder
    wire ps2_clk_neg;           // True at the negedge of the PS2 clock
    assign ps2_clk_neg = ~ps2_clk_state[0] & ps2_clk_state[1];
    
    // Registers for data reading
    reg [3:0] read_state;
    reg [7:0] read_data;
    
    // Registers for special signals
    reg is_f0, is_e0;
    
    // Record the PS2 clock
    always @ (posedge clk or negedge rst)
        if (!rst)
            ps2_clk_state <= 2'b0;
        else
            ps2_clk_state <= {ps2_clk_state[0], ps2_clk};
    
    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            read_state <= 4'b0;
            read_data <= 8'b0;
            
            is_f0 <= 1'b0;
            is_e0 <= 1'b0;
            crt_data <= 9'b0;
        end
        else if (ps2_clk_neg) begin
            // Reads in the data
            if (read_state > 4'b1001)
                read_state <= 4'b0;
            else begin
                if (read_state > 4'b0 && read_state < 4'b1001)
                    read_data[read_state - 1] <= ps2_data;
                read_state <= read_state + 1'b1;
            end
        end
        else if (read_state == 4'b1010 && |read_data) begin
            if (read_data == 8'hf0)
                is_f0 <= 1'b1;
            else if (read_data == 8'he0)
                is_e0 <= 1'b1;
            else
                if (is_f0) begin
                    // A key is released
                    is_f0 <= 1'b0;
                    is_e0 <= 1'b0;
                    crt_data <= 9'b0;
                end
                else if (is_e0) begin
                    is_e0 <= 1'b0;
                    crt_data <= {1'b1, read_data};
                end
                else
                    crt_data <= {1'b0, read_data};
            
            read_data <= 8'b0;
        end
    end
    
endmodule
