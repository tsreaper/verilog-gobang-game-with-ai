`timescale 1ns / 1ps

module gobang_datapath_tb;

    // Inputs
    reg clk;
    reg rst;
    reg clr;
    reg write;
    reg [3:0] write_x;
    reg [3:0] write_y;
    reg write_color;
    reg [3:0] get_x;
    reg [3:0] get_y;

    // Outputs
    wire [8:0] black_x;
    wire [8:0] black_y;
    wire [8:0] black_xy;
    wire [8:0] black_yx;
    wire [8:0] white_x;
    wire [8:0] white_y;
    wire [8:0] white_xy;
    wire [8:0] white_yx;
    wire [224:0] black_data;
    wire [224:0] white_data;

    // Instantiate the Unit Under Test (UUT)
    gobang_datapath uut (
        .clk(clk), 
        .rst(rst), 
        .clr(clr), 
        .write(write), 
        .write_x(write_x), 
        .write_y(write_y), 
        .write_color(write_color), 
        .get_x(get_x), 
        .get_y(get_y), 
        .black_x(black_x), 
        .black_y(black_y), 
        .black_xy(black_xy), 
        .black_yx(black_yx), 
        .white_x(white_x), 
        .white_y(white_y), 
        .white_xy(white_xy), 
        .white_yx(white_yx), 
        .black_data(black_data), 
        .white_data(white_data)
    );
    
    initial begin
        clk = 0;
        rst = 1;
        write = 0;
        write_x = 0;
        write_y = 0;
        write_color = 0;
        get_x = 1;
        get_y = 1;
        #70;
        
        rst = 0;
        write = 1;
        write_x = 1;
        write_y = 1;
        write_color = 0;
        #50;
        
        write = 0;
        #50;
        
        write = 1;
        write_x = 2;
        write_y = 1;
        write_color = 1;
        #50;
        
        write = 0;
    end
    
    always begin
        #50;
        clk = ~clk;
    end
      
endmodule

