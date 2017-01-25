`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// A simple strategy for the gobang game.
//------------------------------------------------------------------------------
module gobang_strategy(
    input wire clk,                        // Clock
    input wire rst,                        // Reset
    input wire clr,                        // Clear
    input wire active,                     // Active signal
    input wire random,                     // Random signal
    
    input wire [8:0] black_i,              // Row information
    input wire [8:0] black_j,              // Column information
    input wire [8:0] black_ij,             // Main diagonal information
    input wire [8:0] black_ji,             // Counter diagonal information
    input wire [8:0] white_i,
    input wire [8:0] white_j,
    input wire [8:0] white_ij,
    input wire [8:0] white_ji,
    
    output reg [3:0] get_i,                // Current row considered
    output reg [3:0] get_j,                // Current column considered
    
    output reg [12:0] black_best_score,    // Best possible score
    output reg [3:0] black_best_i,         // Best row
    output reg [3:0] black_best_j,         // Best column
    output reg [12:0] white_best_score,
    output reg [3:0] white_best_i,
    output reg [3:0] white_best_j
    );
    
    // Chessboard parameters
    localparam BOARD_SIZE = 15;
    
    // State parameters
    localparam STATE_IDLE = 1'b0,
               STATE_WORKING = 1'b1;
    
    reg state;    // Current state
    
    // Scores of the four directions
    wire [12:0] black_score_i, black_score_j, black_score_ij, black_score_ji;
    wire [12:0] white_score_i, white_score_j, white_score_ij, white_score_ji;
    
    // Total scores
    wire [12:0] black_score, white_score;
    assign black_score = black_score_i + black_score_j +
                         black_score_ij + black_score_ji;
    assign white_score = white_score_i + white_score_j +
                         white_score_ij + white_score_ji;
    
    // Score calculators
    score_calculator
        calc_black_i(
            .my(black_i),
            .op(white_i),
            .score(black_score_i)
        ),
        calc_black_j(
            .my(black_j),
            .op(white_j),
            .score(black_score_j)
        ),
        calc_black_ij(
            .my(black_ij),
            .op(white_ij),
            .score(black_score_ij)
        ),
        calc_black_ji(
            .my(black_ji),
            .op(white_ji),
            .score(black_score_ji)
        ),
        calc_white_i(
            .my(white_i),
            .op(black_i),
            .score(white_score_i)
        ),
        calc_white_j(
            .my(white_j),
            .op(black_j),
            .score(white_score_j)
        ),
        calc_white_ij(
            .my(white_ij),
            .op(black_ij),
            .score(white_score_ij)
        ),
        calc_white_ji(
            .my(white_ji),
            .op(black_ji),
            .score(white_score_ji)
        );
    
    // FSM of the strategy
    // Every time the active signal comes, the strategy will run once
    always @ (posedge clk or negedge rst) begin
        if (!rst || clr) begin
            get_i <= 4'b0;
            get_j <= 4'b0;
            black_best_score <= 0;
            black_best_i <= BOARD_SIZE / 2;
            black_best_j <= BOARD_SIZE / 2;
            white_best_score <= 0;
            white_best_i <= BOARD_SIZE / 2;
            white_best_j <= BOARD_SIZE / 2;
            
            state <= STATE_IDLE;
        end
        else if (!active && state == STATE_IDLE)
            state <= STATE_WORKING;
        else if (active && state == STATE_WORKING) begin
            // Calculate the best positions
            if ((get_i == 4'b0 && get_j == 4'b0) ||
                black_score > black_best_score ||
                (black_score == black_best_score && random)) begin
                black_best_score <= black_score;
                black_best_i <= get_i;
                black_best_j <= get_j;
            end
            if ((get_i == 4'b0 && get_j == 4'b0) ||
                white_score > white_best_score ||
                (white_score == white_best_score && random)) begin
                white_best_score <= white_score;
                white_best_i <= get_i;
                white_best_j <= get_j;
            end
            
            // Move to the next position
            if (get_j == BOARD_SIZE - 1) begin
                if (get_i == BOARD_SIZE - 1) begin
                    get_i <= 4'b0;
                    get_j <= 4'b0;
                    state <= STATE_IDLE;
                end
                else begin
                    get_i <= get_i + 1'b1;
                    get_j <= 4'b0;
                end
            end
            else
                get_j <= get_j + 1'b1;
        end
    end

endmodule
