`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Generate the VGA control signal
//------------------------------------------------------------------------------
module vga_sync(
    input wire clk,          // Clock (25MHz)
    input wire rst,          // Reset
    output wire sync_h,      // VGA horizontal sync
    output wire sync_v,      // VGA vertical sync
    output wire video_on,    // True when in the display area
    output reg [9:0] x,      // X coordinate
    output reg [9:0] y       // Y coordinate
    );
    
    assign sync_h = ~(x > 655 && x < 752);
    assign sync_v = ~(y > 489 && y < 492);
    assign video_on = (x < 640 && y < 480);
     
    always @ (posedge clk or negedge rst) begin
        if (!rst) begin
            x <= 0;
            y <= 0;
        end
        else begin
            if (x == 799)
                x <= 0;
            else
                x <= x + 1'b1;
            if (y == 524)
                y <= 0;
            else if (x == 799)
                y <= y + 1'b1;
        end
    end
    
endmodule
