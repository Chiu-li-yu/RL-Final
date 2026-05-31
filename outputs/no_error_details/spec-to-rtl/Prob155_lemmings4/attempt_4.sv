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

    typedef enum logic [3:0] {
        WALK_LEFT, WALK_RIGHT, FALL_LEFT, FALL_RIGHT, DIG_LEFT, DIG_RIGHT, SPLATTER
    } state_t;

    state_t state, next_state;
    logic [5:0] fall_cnt;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_LEFT;
            fall_cnt <= 6'd0;
        end else begin
            state <= next_state;
            if (next_state == FALL_LEFT || next_state == FALL_RIGHT)
                fall_cnt <= (state == FALL_LEFT || state == FALL_RIGHT) ? fall_cnt + 6'd1 : 6'd1;
            else
                fall_cnt <= 6'd0;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            WALK_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
                else if (dig) next_state = DIG_LEFT;
                else if (bump_left) next_state = WALK_RIGHT;
            end
            WALK_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
                else if (dig) next_state = DIG_RIGHT;
                else if (bump_right) next_state = WALK_LEFT;
            end
            FALL_LEFT: begin
                if (ground) next_state = (fall_cnt > 6'd20) ? SPLATTER : WALK_LEFT;
            end
            FALL_RIGHT: begin
                if (ground) next_state = (fall_cnt > 6'd20) ? SPLATTER : WALK_RIGHT;
            end
            DIG_LEFT: begin
                if (!ground) next_state = FALL_LEFT;
            end
            DIG_RIGHT: begin
                if (!ground) next_state = FALL_RIGHT;
            end
            SPLATTER: next_state = SPLATTER;
        endcase
    end

    assign walk_left = (state == WALK_LEFT);
    assign walk_right = (state == WALK_RIGHT);
    assign aaah = (state == FALL_LEFT || state == FALL_RIGHT);
    assign digging = (state == DIG_LEFT || state == DIG_RIGHT);

endmodule
