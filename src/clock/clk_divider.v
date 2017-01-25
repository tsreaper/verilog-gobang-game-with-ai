`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Clock division module
//------------------------------------------------------------------------------
module clk_divider(
    input wire clk,              // Clock
    input wire rst,              // Reset
    output reg [31:0] clk_div    // Division result
    );
    
    always @ (posedge clk or negedge rst)
        if (!rst)
            clk_div <= 32'b0;
        else
            clk_div <= clk_div + 1;
    
endmodule
