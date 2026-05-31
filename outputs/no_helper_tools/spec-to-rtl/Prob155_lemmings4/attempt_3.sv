module TopModule(
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

    parameter S_WALK_LEFT = 0, S_WALK_RIGHT = 1, S_FALL_LEFT = 2, S_FALL_RIGHT = 3, S_DIG_LEFT = 4, S_DIG_RIGHT = 5, S_SPLAT = 6;
    
    logic [2:0] state, next_state;
    logic [6:0] fall_cnt;

    assign walk_left = (state == S_WALK_LEFT);
    assign walk_right = (state == S_WALK_RIGHT);
    assign aaah = (state == S_FALL_LEFT || state == S_FALL_RIGHT);
    assign digging = (state == S_DIG_LEFT || state == S_DIG_RIGHT);

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WALK_LEFT;
            fall_cnt <= 0;
        end else begin
            state <= next_state;
            if (state == S_FALL_LEFT || state == S_FALL_RIGHT) begin
                if (!ground) fall_cnt <= fall_cnt + 1;
            end else begin
                fall_cnt <= 0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_WALK_LEFT: begin
                if (!ground) next_state = S_FALL_LEFT;
                else if (dig) next_state = S_DIG_LEFT;
                else if (bump_left) next_state = S_WALK_RIGHT;
                else if (bump_right) next_state = S_WALK_LEFT;
            end
            S_WALK_RIGHT: begin
                if (!ground) next_state = S_FALL_RIGHT;
                else if (dig) next_state = S_DIG_RIGHT;
                else if (bump_right) next_state = S_WALK_LEFT;
                else if (bump_left) next_state = S_WALK_RIGHT;
            end
            S_FALL_LEFT: begin
                if (ground) next_state = (fall_cnt > 20) ? S_SPLAT : S_WALK_LEFT;
            end
            S_FALL_RIGHT: begin
                if (ground) next_state = (fall_cnt > 20) ? S_SPLAT : S_WALK_RIGHT;
            end
            S_DIG_LEFT: begin
                if (!ground) next_state = S_FALL_LEFT;
            end
            S_DIG_RIGHT: begin
                if (!ground) next_state = S_FALL_RIGHT;
            end
            S_SPLAT: next_state = S_SPLAT;
        endcase
    end
endmodule