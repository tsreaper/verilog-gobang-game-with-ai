`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Generate a random number
//------------------------------------------------------------------------------
module random_generator(
    input wire clk,               // Clock
    input wire rst,               // Reset
    input wire load,              // Load signal
    input wire [31:0] seed,       // Random seed
    output reg [31:0] rand_num    // A random number
    );
    
    always @ (posedge clk or negedge rst)
        if (!rst)
            rand_num <= 32'b0;
        else if (load)
            // Load the random seed
            rand_num <= seed;
        else
            rand_num <= {rand_num[30:0],
                         rand_num[31] ^ rand_num[29] ^ rand_num[28] ^
                         rand_num[27] ^ rand_num[23] ^ rand_num[20] ^
                         rand_num[19] ^ rand_num[17] ^ rand_num[15] ^
                         rand_num[14] ^ rand_num[12] ^ rand_num[11] ^
                         rand_num[9]  ^ rand_num[4]  ^ rand_num[3]  ^
                         rand_num[2]};
    
endmodule
