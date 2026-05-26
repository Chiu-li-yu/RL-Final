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

    parameter WALK_LEFT = 3'd0, WALK_RIGHT = 3'd1, FALL_LEFT = 3'd2, FALL_RIGHT = 3'd3, DIG_LEFT = 3'd4, DIG_RIGHT = 3'd5, SPLATTER = 3'd6;

    logic [2:0] state, next_state;
    logic [4:0] fall_counter, next_fall_counter;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_counter <= 5'd0;
        end else begin
            state <= next_state;
            fall_counter <= next_fall_counter;
        end
    end

    always @(*) begin
        next_state = state;
        next_fall_counter = fall_counter;

        case (state)
            WALK_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
                else if (dig) next_state = DIG_LEFT;
                else if (bump_left) next_state = WALK_RIGHT;
                else if (bump_right) next_state = WALK_LEFT;
            end
            WALK_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
                else if (dig) next_state = DIG_RIGHT;
                else if (bump_right) next_state = WALK_LEFT;
                else if (bump_left) next_state = WALK_RIGHT;
            end
            DIG_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
            end
            FALL_LEFT: begin
                next_fall_counter = fall_counter + 5'd1;
                if (ground) begin
                    next_state = (fall_counter > 5'd20) ? SPLATTER : WALK_LEFT;
                    next_fall_counter = 5'd0;
                end
            end
            FALL_RIGHT: begin
                next_fall_counter = fall_counter + 5'd1;
                if (ground) begin
                    next_state = (fall_counter > 5'd20) ? SPLATTER : WALK_RIGHT;
                    next_fall_counter = 5'd0;
                end
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