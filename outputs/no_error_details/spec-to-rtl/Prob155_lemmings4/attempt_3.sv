module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    localparam WALK_LEFT  = 4'd0;
    localparam WALK_RIGHT = 4'd1;
    localparam FALL_LEFT  = 4'd2;
    localparam FALL_RIGHT = 4'd3;
    localparam DIG_LEFT   = 4'd4;
    localparam DIG_RIGHT  = 4'd5;
    localparam SPLATTER   = 4'd6;

    logic [3:0] state, next_state;
    logic [5:0] fall_counter;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 6'b0;
        end else begin
            state <= next_state;
            if (next_state == FALL_LEFT || next_state == FALL_RIGHT)
                fall_counter <= (state == FALL_LEFT || state == FALL_RIGHT) ? fall_counter + 6'd1 : 6'd1;
            else
                fall_counter <= 6'b0;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
                else if (dig) next_state = DIG_LEFT;
                else if (bump_left || bump_right) next_state = WALK_RIGHT;
            end
            WALK_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
                else if (dig) next_state = DIG_RIGHT;
                else if (bump_right || bump_left) next_state = WALK_LEFT;
            end
            FALL_LEFT: begin
                if (ground) begin
                    if (fall_counter > 6'd20) next_state = SPLATTER;
                    else next_state = WALK_LEFT;
                end
            end
            FALL_RIGHT: begin
                if (ground) begin
                    if (fall_counter > 6'd20) next_state = SPLATTER;
                    else next_state = WALK_RIGHT;
                end
            end
            DIG_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
            end
            SPLATTER: next_state = SPLATTER;
            default: next_state = WALK_LEFT;
        endcase
    end

    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule
