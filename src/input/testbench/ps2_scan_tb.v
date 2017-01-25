`timescale 1ns / 1ps

module ps2_scan_tb;

    // Inputs
    reg clk;
    reg rst;
    reg ps2_clk;
    reg ps2_data;

    // Outputs
    wire [8:0] crt_data;

    // Instantiate the Unit Under Test (UUT)
    ps2_scan uut (
        .clk(clk), 
        .rst(rst), 
        .ps2_clk(ps2_clk), 
        .ps2_data(ps2_data), 
        .crt_data(crt_data)
    );
    
    reg [3:0] i;
    
    localparam [7:0] SPACE = 8'h29, UP = 8'h75;
    localparam [7:0] E0 = 8'he0, F0 = 8'hf0;

    initial begin
        clk = 0;
        rst = 1;
        ps2_clk = 1;
        ps2_data = 0;
        #50;
        
        rst = 0;
        #30;
        
        rst = 1;
        #30;
        
        // space
        for (i=0;i<11;i=i+1) begin
            ps2_clk = 1;
            if (i > 0 && i < 9)
                ps2_data = SPACE[i-1];
            #30;
            
            ps2_clk = 0;
            #30;
        end
        
        ps2_clk = 1;
        #30;
        
        // e0
        for (i=0;i<11;i=i+1) begin
            ps2_clk = 1;
            if (i > 0 && i < 9)
                ps2_data = E0[i-1];
            #30;
            
            ps2_clk = 0;
            #30;
        end
        
        ps2_clk = 1;
        #30;
        
        // up
        for (i=0;i<11;i=i+1) begin
            ps2_clk = 1;
            if (i > 0 && i < 9)
                ps2_data = UP[i-1];
            #30;
            
            ps2_clk = 0;
            #30;
        end
        
        ps2_clk = 1;
        #30;
        
        // f0
        for (i=0;i<11;i=i+1) begin
            ps2_clk = 1;
            if (i > 0 && i < 9)
                ps2_data = F0[i-1];
            #30;
            
            ps2_clk = 0;
            #30;
        end
        
        ps2_clk = 1;
        #30;
        
        // space
        for (i=0;i<11;i=i+1) begin
            ps2_clk = 1;
            if (i > 0 && i < 9)
                ps2_data = SPACE[i-1];
            #30;
            
            ps2_clk = 0;
            #30;
        end
        
        ps2_clk = 1;
        #30;
    end
    
    always begin
        #5;
        clk = ~clk;
    end
      
endmodule

