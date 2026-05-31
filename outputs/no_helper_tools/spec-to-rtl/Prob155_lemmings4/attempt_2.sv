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

    typedef enum logic [2:0] {
        S_WALK_LEFT = 3'd0, S_WALK_RIGHT = 3'd1, 
        S_FALL_LEFT = 3'd2, S_FALL_RIGHT = 3'd3, 
        S_DIG_LEFT = 3'd4, S_DIG_RIGHT = 3'd5, 
        S_SPLAT = 3'd6
    } state_t;
    
    state_t state, next_state;
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
                if (ground) fall_cnt <= 0;
                else if (fall_cnt < 7'd100) fall_cnt <= fall_cnt + 1'b1;
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
                else if (bump_left && bump_right) next_state = S_WALK_RIGHT;
                else if (bump_left) next_state = S_WALK_RIGHT;
                else if (bump_right) next_state = S_WALK_LEFT;
            end
            S_WALK_RIGHT: begin
                if (!ground) next_state = S_FALL_RIGHT;
                else if (dig) next_state = S_DIG_RIGHT;
                else if (bump_left && bump_right) next_state = S_WALK_LEFT;
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