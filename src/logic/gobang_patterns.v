`timescale 1ns / 1ps
//------------------------------------------------------------------------------
// _ = empty | * = my chess | o = opponent's chess
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Recognize *****
//------------------------------------------------------------------------------
module pattern_five(
    input wire [8:0] my,
    output reg ret
    );
    
    always @ (*)
        if ((my[0] && my[1] && my[2] && my[3] && my[4]) ||
            (my[1] && my[2] && my[3] && my[4] && my[5]) ||
            (my[2] && my[3] && my[4] && my[5] && my[6]) ||
            (my[3] && my[4] && my[5] && my[6] && my[7]) ||
            (my[4] && my[5] && my[6] && my[7] && my[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize _****_
//------------------------------------------------------------------------------
module pattern_four(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((empty[0] && my[1] && my[2] && my[3] && my[4] && empty[5]) ||
            (empty[1] && my[2] && my[3] && my[4] && my[5] && empty[6]) ||
            (empty[2] && my[3] && my[4] && my[5] && my[6] && empty[7]) ||
            (empty[3] && my[4] && my[5] && my[6] && my[7] && empty[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize o****_ | _****o | *_*** | ***_* | **_**
//------------------------------------------------------------------------------
module pattern_ffour(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((op[0] && my[1] && my[2] && my[3] && my[4] && empty[5]) ||
            (op[1] && my[2] && my[3] && my[4] && my[5] && empty[6]) ||
            (op[2] && my[3] && my[4] && my[5] && my[6] && empty[7]) ||
            (op[3] && my[4] && my[5] && my[6] && my[7] && empty[8]) ||
            (empty[0] && my[1] && my[2] && my[3] && my[4] && op[5]) ||
            (empty[1] && my[2] && my[3] && my[4] && my[5] && op[6]) ||
            (empty[2] && my[3] && my[4] && my[5] && my[6] && op[7]) ||
            (empty[3] && my[4] && my[5] && my[6] && my[7] && op[8]) ||
            (my[0] && empty[1] && my[2] && my[3] && my[4]) ||
            (my[1] && empty[2] && my[3] && my[4] && my[5]) ||
            (my[2] && empty[3] && my[4] && my[5] && my[6]) ||
            (my[3] && empty[4] && my[5] && my[6] && my[7]) ||
            (my[4] && empty[5] && my[6] && my[7] && my[8]) ||
            (my[0] && my[1] && my[2] && empty[3] && my[4]) ||
            (my[1] && my[2] && my[3] && empty[4] && my[5]) ||
            (my[2] && my[3] && my[4] && empty[5] && my[6]) ||
            (my[3] && my[4] && my[5] && empty[6] && my[7]) ||
            (my[4] && my[5] && my[6] && empty[7] && my[8]) ||
            (my[0] && my[1] && empty[2] && my[3] && my[4]) ||
            (my[1] && my[2] && empty[3] && my[4] && my[5]) ||
            (my[2] && my[3] && empty[4] && my[5] && my[6]) ||
            (my[3] && my[4] && empty[5] && my[6] && my[7]) ||
            (my[4] && my[5] && empty[6] && my[7] && my[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize _***_ | _**_*_ | _*_**_
//------------------------------------------------------------------------------
module pattern_three(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((empty[0] && my[1] && my[2] && my[3] && empty[4]) ||
            (empty[1] && my[2] && my[3] && my[4] && empty[5]) ||
            (empty[2] && my[3] && my[4] && my[5] && empty[6]) ||
            (empty[3] && my[4] && my[5] && my[6] && empty[7]) ||
            (empty[4] && my[5] && my[6] && my[7] && empty[8]) ||
            (empty[0] && my[1] && my[2] && empty[3] && my[4] && empty[5]) ||
            (empty[1] && my[2] && my[3] && empty[4] && my[5] && empty[6]) ||
            (empty[2] && my[3] && my[4] && empty[5] && my[6] && empty[7]) ||
            (empty[3] && my[4] && my[5] && empty[6] && my[7] && empty[8]) ||
            (empty[0] && my[1] && empty[2] && my[3] && my[4] && empty[5]) ||
            (empty[1] && my[2] && empty[3] && my[4] && my[5] && empty[6]) ||
            (empty[2] && my[3] && empty[4] && my[5] && my[6] && empty[7]) ||
            (empty[3] && my[4] && empty[5] && my[6] && my[7] && empty[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize o_*** | ***_o
//------------------------------------------------------------------------------
module pattern_fthree(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((op[0] && empty[1] && my[2] && my[3] && my[4]) ||
            (op[1] && empty[2] && my[3] && my[4] && my[5]) ||
            (op[2] && empty[3] && my[4] && my[5] && my[6]) ||
            (op[3] && empty[4] && my[5] && my[6] && my[7]) ||
            (op[4] && empty[5] && my[6] && my[7] && my[8]) ||
            (my[0] && my[1] && my[2] && empty[3] && op[4]) ||
            (my[1] && my[2] && my[3] && empty[4] && op[5]) ||
            (my[2] && my[3] && my[4] && empty[5] && op[6]) ||
            (my[3] && my[4] && my[5] && empty[6] && op[7]) ||
            (my[4] && my[5] && my[6] && empty[7] && op[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize _**_ | _*_*_
//------------------------------------------------------------------------------
module pattern_two(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((empty[0] && my[1] && my[2] && empty[3]) ||
            (empty[1] && my[2] && my[3] && empty[4]) ||
            (empty[2] && my[3] && my[4] && empty[5]) ||
            (empty[3] && my[4] && my[5] && empty[6]) ||
            (empty[4] && my[5] && my[6] && empty[7]) ||
            (empty[5] && my[6] && my[7] && empty[8]) ||
            (empty[0] && my[1] && empty[2] && my[3] && empty[4]) ||
            (empty[1] && my[2] && empty[3] && my[4] && empty[5]) ||
            (empty[2] && my[3] && empty[4] && my[5] && empty[6]) ||
            (empty[3] && my[4] && empty[5] && my[6] && empty[7]) ||
            (empty[4] && my[5] && empty[6] && my[7] && empty[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize o***_ | _***o
//------------------------------------------------------------------------------
module pattern_sthree(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((op[0] && my[1] && my[2] && my[3] && empty[4]) ||
            (op[1] && my[2] && my[3] && my[4] && empty[5]) ||
            (op[2] && my[3] && my[4] && my[5] && empty[6]) ||
            (op[3] && my[4] && my[5] && my[6] && empty[7]) ||
            (op[4] && my[5] && my[6] && my[7] && empty[8]) ||
            (empty[0] && my[1] && my[2] && my[3] && op[4]) ||
            (empty[1] && my[2] && my[3] && my[4] && op[5]) ||
            (empty[2] && my[3] && my[4] && my[5] && op[6]) ||
            (empty[3] && my[4] && my[5] && my[6] && op[7]) ||
            (empty[4] && my[5] && my[6] && my[7] && op[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize o_** | **_o
//------------------------------------------------------------------------------
module pattern_ftwo(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((op[0] && empty[1] && my[2] && my[3]) ||
            (op[1] && empty[2] && my[3] && my[4]) ||
            (op[2] && empty[3] && my[4] && my[5]) ||
            (op[3] && empty[4] && my[5] && my[6]) ||
            (op[4] && empty[5] && my[6] && my[7]) ||
            (op[5] && empty[6] && my[7] && my[8]) ||
            (my[0] && my[1] && empty[2] && op[3]) ||
            (my[1] && my[2] && empty[3] && op[4]) ||
            (my[2] && my[3] && empty[4] && op[5]) ||
            (my[3] && my[4] && empty[5] && op[6]) ||
            (my[4] && my[5] && empty[6] && op[7]) ||
            (my[5] && my[6] && empty[7] && op[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule

//------------------------------------------------------------------------------
// Recognize o**_ | _**o
//------------------------------------------------------------------------------
module pattern_stwo(
    input wire [8:0] my,
    input wire [8:0] op,
    output reg ret
    );
    
    wire [8:0] empty;
    assign empty = ~(my | op);
    
    always @ (*)
        if ((op[0] && my[1] && my[2] && empty[3]) ||
            (op[1] && my[2] && my[3] && empty[4]) ||
            (op[2] && my[3] && my[4] && empty[5]) ||
            (op[3] && my[4] && my[5] && empty[6]) ||
            (op[4] && my[5] && my[6] && empty[7]) ||
            (op[5] && my[6] && my[7] && empty[8]) ||
            (empty[0] && my[1] && my[2] && op[3]) ||
            (empty[1] && my[2] && my[3] && op[4]) ||
            (empty[2] && my[3] && my[4] && op[5]) ||
            (empty[3] && my[4] && my[5] && op[6]) ||
            (empty[4] && my[5] && my[6] && op[7]) ||
            (empty[5] && my[6] && my[7] && op[8]))
            ret = 1'b1;
        else
            ret = 1'b0;

endmodule
