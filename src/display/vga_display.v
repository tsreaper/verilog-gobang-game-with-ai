`timescale 1ns / 1ps

//------------------------------------------------------------------------------
// Display the color for each pixel
//------------------------------------------------------------------------------
module vga_display(
    input wire clk,                     // Clock (25MHz)
    input wire rst,                     // Reset
    
    input wire [3:0] cursor_i,          // Cursor position
    input wire [3:0] cursor_j,
    input wire black_is_player,         // If black is not AI
    input wire white_is_player,         // If white is not AI
    input wire crt_player,              // Current player
    input wire game_running,            // If the game is running
    input wire [1:0] winner,            // Who wins the game
    
    input wire [14:0] display_black,    // Row information for display
    input wire [14:0] display_white,
    
    output wire [3:0] display_i,        // Row needed by display
    output wire sync_h,                 // VGA horizontal sync
    output wire sync_v,                 // VGA vertical sync
    output wire [3:0] r,                // VGA red component
    output wire [3:0] g,                // VGA green component
    output wire [3:0] b                 // VGA blue component
    );
    
    // Side parameters
    localparam BLACK = 1'b0,
               WHITE = 1'b1;
    
    // Chessboard display parameters
    localparam BOARD_SIZE = 15,
               GRID_SIZE = 23,
               GRID_X_BEGIN = 148,
               GRID_X_END = 492,
               GRID_Y_BEGIN = 68,
               GRID_Y_END = 412;
    
    // Side information display parameters
    localparam SIDE_BLACK_X_BEGIN = 545,
               SIDE_BLACK_X_END = 616,
               SIDE_BLACK_Y_BEGIN = 182,
               SIDE_BLACK_Y_END = 200,
               SIDE_WHITE_X_BEGIN = 545,
               SIDE_WHITE_X_END = 616,
               SIDE_WHITE_Y_BEGIN = 278,
               SIDE_WHITE_Y_END = 296;
    
    // Current player pointer display parameters
    localparam CRT_BLACK_X_BEGIN = 510,
               CRT_BLACK_X_END = 541,
               CRT_BLACK_Y_BEGIN = 185,
               CRT_BLACK_Y_END = 198,
               CRT_WHITE_X_BEGIN = 510,
               CRT_WHITE_X_END = 541,
               CRT_WHITE_Y_BEGIN = 281,
               CRT_WHITE_Y_END = 294;
    
    // Title display parameters
    localparam TITLE_X_BEGIN = 0,
               TITLE_X_END = 140,
               TITLE_Y_BEGIN = 62,
               TITLE_Y_END = 418;
    
    // Instruction display parameters
    localparam INS_X_BEGIN = 145,
               INS_X_END = 494,
               INS_Y_BEGIN = 424,
               INS_Y_END = 467;
    
    // Result display parameters
    localparam RES_X_BEGIN = 187,
               RES_X_END = 452,
               RES_Y_BEGIN = 20,
               RES_Y_END = 47;
    
    // Author info display parameters
    localparam AUTHOR_X_BEGIN = 510,
               AUTHOR_X_END = 634,
               AUTHOR_Y_BEGIN = 455,
               AUTHOR_Y_END = 476;
    
    
    
    // Current display color
    reg [11:0] rgb;
    assign r = video_on ? rgb[11:8] : 4'b0;
    assign g = video_on ? rgb[7:4]  : 4'b0;
    assign b = video_on ? rgb[3:0]  : 4'b0;
    
    // VGA control signal generator
    wire video_on;
    wire [9:0] x, y;
    vga_sync
        sync(
            .clk(clk),
            .rst(rst),
            .sync_h(sync_h),
            .sync_v(sync_v),
            .video_on(video_on),
            .x(x),
            .y(y)
        );
    
    // Chessboard display registers
    reg [3:0] row, col;
    integer delta_x, delta_y;
    assign display_i = row < BOARD_SIZE ? row : 4'b0;
    
    // Patterns needed to be displayed
    wire [22:0] chess_piece_data;
    pic_chess_piece chess_piece(x >= GRID_X_BEGIN && x <= GRID_X_END &&
                                y >= GRID_Y_BEGIN && y <= GRID_Y_END,
                                delta_y + GRID_SIZE/2, chess_piece_data);
    
    wire [71:0] black_player_data, black_ai_data,
                white_player_data, white_ai_data;
    pic_side_player black_player(x >= SIDE_BLACK_X_BEGIN &&
                                 x <= SIDE_BLACK_X_END &&
                                 y >= SIDE_BLACK_Y_BEGIN &&
                                 y <= SIDE_BLACK_Y_END,
                                 y - SIDE_BLACK_Y_BEGIN, black_player_data),
                    white_player(x >= SIDE_WHITE_X_BEGIN &&
                                 x <= SIDE_WHITE_X_END &&
                                 y >= SIDE_WHITE_Y_BEGIN &&
                                 y <= SIDE_WHITE_Y_END,
                                 y - SIDE_WHITE_Y_BEGIN, white_player_data);
    pic_side_ai black_ai(x >= SIDE_BLACK_X_BEGIN && x <= SIDE_BLACK_X_END &&
                         y >= SIDE_BLACK_Y_BEGIN && y <= SIDE_BLACK_Y_END,
                         y - SIDE_BLACK_Y_BEGIN, black_ai_data),
                white_ai(x >= SIDE_WHITE_X_BEGIN && x <= SIDE_WHITE_X_END &&
                         y >= SIDE_WHITE_Y_BEGIN && y <= SIDE_WHITE_Y_END,
                         y - SIDE_WHITE_Y_BEGIN, white_ai_data);
    
    wire [31:0] black_ptr_data, white_ptr_data;
    pic_crt_ptr black_ptr(x >= CRT_BLACK_X_BEGIN && x <= CRT_BLACK_X_END &&
                          y >= CRT_BLACK_Y_BEGIN && y <= CRT_BLACK_Y_END,
                          y - CRT_BLACK_Y_BEGIN, black_ptr_data),
                white_ptr(x >= CRT_WHITE_X_BEGIN && x <= CRT_WHITE_X_END &&
                          y >= CRT_WHITE_Y_BEGIN && y <= CRT_WHITE_Y_END,
                          y - CRT_WHITE_Y_BEGIN, white_ptr_data);
    
    wire [140:0] title_data;
    pic_title title(x >= TITLE_X_BEGIN && x <= TITLE_X_END &&
                    y >= TITLE_Y_BEGIN && y <= TITLE_Y_END,
                    y - TITLE_Y_BEGIN, title_data);
    
    wire [349:0] ins_start_data, ins_player_data, ins_ai_data;
    pic_ins_start ins_start(x >= INS_X_BEGIN && x <= INS_X_END &&
                            y >= INS_Y_BEGIN && y <= INS_Y_END,
                            y - INS_Y_BEGIN, ins_start_data);
    pic_ins_player ins_player(x >= INS_X_BEGIN && x <= INS_X_END &&
                              y >= INS_Y_BEGIN && y <= INS_Y_END,
                              y - INS_Y_BEGIN, ins_player_data);
    pic_ins_ai ins_ai(x >= INS_X_BEGIN && x <= INS_X_END &&
                      y >= INS_Y_BEGIN && y <= INS_Y_END,
                      y - INS_Y_BEGIN, ins_ai_data);
    
    wire [265:0] black_wins_data, white_wins_data, res_draw_data;
    pic_black_wins black_wins(x >= RES_X_BEGIN && x <= RES_X_END &&
                              y >= RES_Y_BEGIN && y <= RES_Y_END,
                              y - RES_Y_BEGIN, black_wins_data);
    pic_white_wins white_wins(x >= RES_X_BEGIN && x <= RES_X_END &&
                              y >= RES_Y_BEGIN && y <= RES_Y_END,
                              y - RES_Y_BEGIN, white_wins_data);
    pic_res_draw res_draw(x >= RES_X_BEGIN && x <= RES_X_END &&
                          y >= RES_Y_BEGIN && y <= RES_Y_END,
                          y - RES_Y_BEGIN, res_draw_data);
    
    wire [124:0] author_info_data;
    pic_author_info author_info(x >= AUTHOR_X_BEGIN && x <= AUTHOR_X_END &&
                                y >= AUTHOR_Y_BEGIN && y <= AUTHOR_Y_END,
                                y - AUTHOR_Y_BEGIN, author_info_data);
    
    // Calculate the current row and column
    always @ (x or y) begin
        if (y >= GRID_Y_BEGIN &&
            y < GRID_Y_BEGIN + GRID_SIZE)
            row = 4'b0000;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE &&
                 y < GRID_Y_BEGIN + GRID_SIZE*2)
            row = 4'b0001;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*2 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*3)
            row = 4'b0010;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*3 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*4)
            row = 4'b0011;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*4 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*5)
            row = 4'b0100;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*5 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*6)
            row = 4'b0101;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*6 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*7)
            row = 4'b0110;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*7 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*8)
            row = 4'b0111;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*8 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*9)
            row = 4'b1000;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*9 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*10)
            row = 4'b1001;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*10 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*11)
            row = 4'b1010;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*11 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*12)
            row = 4'b1011;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*12 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*13)
            row = 4'b1100;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*13 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*14)
            row = 4'b1101;
        else if (y >= GRID_Y_BEGIN + GRID_SIZE*14 &&
                 y < GRID_Y_BEGIN + GRID_SIZE*15)
            row = 4'b1110;
        else
            row = 4'b1111;
        
        if (x >= GRID_X_BEGIN &&
            x < GRID_X_BEGIN + GRID_SIZE)
            col = 4'b0000;
        else if (x >= GRID_X_BEGIN + GRID_SIZE &&
                 x < GRID_X_BEGIN + GRID_SIZE*2)
            col = 4'b0001;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*2 &&
                 x < GRID_X_BEGIN + GRID_SIZE*3)
            col = 4'b0010;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*3 &&
                 x < GRID_X_BEGIN + GRID_SIZE*4)
            col = 4'b0011;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*4 &&
                 x < GRID_X_BEGIN + GRID_SIZE*5)
            col = 4'b0100;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*5 &&
                 x < GRID_X_BEGIN + GRID_SIZE*6)
            col = 4'b0101;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*6 &&
                 x < GRID_X_BEGIN + GRID_SIZE*7)
            col = 4'b0110;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*7 &&
                 x < GRID_X_BEGIN + GRID_SIZE*8)
            col = 4'b0111;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*8 &&
                 x < GRID_X_BEGIN + GRID_SIZE*9)
            col = 4'b1000;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*9 &&
                 x < GRID_X_BEGIN + GRID_SIZE*10)
            col = 4'b1001;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*10 &&
                 x < GRID_X_BEGIN + GRID_SIZE*11)
            col = 4'b1010;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*11 &&
                 x < GRID_X_BEGIN + GRID_SIZE*12)
            col = 4'b1011;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*12 &&
                 x < GRID_X_BEGIN + GRID_SIZE*13)
            col = 4'b1100;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*13 &&
                 x < GRID_X_BEGIN + GRID_SIZE*14)
            col = 4'b1101;
        else if (x >= GRID_X_BEGIN + GRID_SIZE*14 &&
                 x < GRID_X_BEGIN + GRID_SIZE*15)
            col = 4'b1110;
        else
            col = 4'b1111;
        
        delta_x = GRID_X_BEGIN + col*GRID_SIZE + GRID_SIZE/2 - x;
        delta_y = GRID_Y_BEGIN + row*GRID_SIZE + GRID_SIZE/2 - y;
    end
    
    // Calculate the color
    always @ (posedge clk) begin
        if (x >= GRID_X_BEGIN && x <= GRID_X_END &&
            y >= GRID_Y_BEGIN && y <= GRID_Y_END) begin
            // Draw the chessboard
            if (display_black[col] &&
                chess_piece_data[delta_x + GRID_SIZE/2])
                // Draw a black chess
                rgb <= 12'h000;
            else if (display_white[col] &&
                     chess_piece_data[delta_x + GRID_SIZE/2])
                // Draw a white chess
                rgb <= 12'hfff;
            else if (row == cursor_i && col == cursor_j &&
                    (delta_x == GRID_SIZE/2 || delta_x == -(GRID_SIZE/2) ||
                     delta_y == GRID_SIZE/2 || delta_y == -(GRID_SIZE/2)))
                // Draw a red square as a cursor
                rgb <= 12'hf00;
            else if (delta_x == 0 || delta_y == 0)
                // Draw the light border of a grid
                rgb <= 12'hda6;
            else if (delta_x == 1 || delta_y == 1)
                // Draw the dark border of a grid
                rgb <= 12'h751;
            else
                rgb <= 12'hc81;
        end
        else if (x >= CRT_BLACK_X_BEGIN && x <= CRT_BLACK_X_END &&
                 y >= CRT_BLACK_Y_BEGIN && y <= CRT_BLACK_Y_END) begin
            // Draw the current player pointer for black side
            rgb <= game_running && crt_player == BLACK && 
                   black_ptr_data[CRT_BLACK_X_END - x] ? 12'h000 : 12'hc81;
        end
        else if (x >= CRT_WHITE_X_BEGIN && x <= CRT_WHITE_X_END &&
                 y >= CRT_WHITE_Y_BEGIN && y <= CRT_WHITE_Y_END) begin
            // Draw the current player pointer for white side
            rgb <= game_running && crt_player == WHITE && 
                   white_ptr_data[CRT_WHITE_X_END - x] ? 12'hfff : 12'hc81;
        end
        else if (x >= SIDE_BLACK_X_BEGIN && x <= SIDE_BLACK_X_END &&
                 y >= SIDE_BLACK_Y_BEGIN && y <= SIDE_BLACK_Y_END) begin
            // Draw who plays the black side
            if (black_is_player)
                rgb <= black_player_data[SIDE_BLACK_X_END - x] ?
                       12'h000 : 12'hc81;
            else
                rgb <= black_ai_data[SIDE_BLACK_X_END - x] ? 12'h000 : 12'hc81;
        end
        else if (x >= SIDE_WHITE_X_BEGIN && x <= SIDE_WHITE_X_END &&
                 y >= SIDE_WHITE_Y_BEGIN && y <= SIDE_WHITE_Y_END) begin
            // Draw who plays the white side
            if (white_is_player)
                rgb <= white_player_data[SIDE_WHITE_X_END - x] ? 
                       12'hfff : 12'hc81;
            else
                rgb <= white_ai_data[SIDE_WHITE_X_END - x] ? 12'hfff : 12'hc81;
        end
        else if (x >= INS_X_BEGIN && x <= INS_X_END &&
                 y >= INS_Y_BEGIN && y <= INS_Y_END) begin
            // Draw instructions
            if (!game_running)
                rgb <= ins_start_data[INS_X_END - x] ? 12'h000 : 12'hc81;
            else if ((black_is_player && crt_player == BLACK) ||
                     (white_is_player && crt_player == WHITE))
                rgb <= ins_player_data[INS_X_END - x] ? 12'h000 : 12'hc81;
            else
                rgb <= ins_ai_data[INS_X_END - x] ? 12'h000 : 12'hc81;
        end
        else if (x >= RES_X_BEGIN && x <= RES_X_END &&
                 y >= RES_Y_BEGIN && y <= RES_Y_END) begin
            // Draw the result
            case (winner)
            2'b00: rgb <= 12'hc81;
            2'b01: rgb <= black_wins_data[RES_X_END - x] ? 12'h000 : 12'hc81;
            2'b10: rgb <= white_wins_data[RES_X_END - x] ? 12'hfff : 12'hc81;
            2'b11: rgb <= res_draw_data[RES_X_END - x] ? 12'hfff : 12'hc81;
            endcase
        end
        else if (x >= TITLE_X_BEGIN && x <= TITLE_X_END &&
                 y >= TITLE_Y_BEGIN && y <= TITLE_Y_END) begin
            // Draw the title
            rgb <= title_data[TITLE_X_END - x] ? 12'hfff : 12'hc81;
        end
        else if (x >= AUTHOR_X_BEGIN && x <= AUTHOR_X_END &&
                 y >= AUTHOR_Y_BEGIN && y <= AUTHOR_Y_END) begin
            // Draw the author info
            rgb <= author_info_data[AUTHOR_X_END - x] ? 12'h000 : 12'hc81;
        end
        else
            // Draw the background
            rgb <= 12'hc81;
    end

endmodule
