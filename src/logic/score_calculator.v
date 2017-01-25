`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Calculate the score of a given pattern
//------------------------------------------------------------------------------
module score_calculator(
    input wire [8:0] my,       // Pattern of my side
    input wire [8:0] op,       // Pattern of the opposite side
    output reg [12:0] score    // The score of the given pattern
    );
    
    wire [8:0] my_next;
    assign my_next = my | 9'b000010000;
    
    wire score2, score4, score5, score8, score15,
         score40, score70, score300, score2000;
    
    // Pattern recognizers
    pattern_stwo pattern2(my_next, op, score2);
    pattern_ftwo pattern4(my_next, op, score4);
    pattern_sthree pattern5(my_next, op, score5);
    pattern_two pattern8(my_next, op, score8);
    pattern_fthree pattern15(my_next, op, score15);
    pattern_three pattern40(my_next, op, score40);
    pattern_ffour pattern70(my_next, op, score70);
    pattern_four pattern300(my_next, op, score300);
    pattern_five pattern2000(my_next, score2000);
    
    always @ (*)
        if (my[4] || op[4])
            // Invalid pattern
            score = 0;
        else if (score2000)
            score = 2000;
        else if (score300)
            score = 300;
        else if (score70)
            score = 70;
        else if (score40)
            score = 40;
        else if (score15)
            score = 15;
        else if (score8)
            score = 8;
        else if (score5)
            score = 5;
        else if (score4)
            score = 4;
        else if (score2)
            score = 2;
        else
            score = 1;
    
endmodule
