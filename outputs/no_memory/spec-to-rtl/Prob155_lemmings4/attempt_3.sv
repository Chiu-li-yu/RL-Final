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
    parameter S_WALK_L = 0, S_WALK_R = 1, S_DIG_L = 2, S_DIG_R = 3, S_FALL_L = 4, S_FALL_R = 5, S_SPLAT = 6;

    logic [2:0] state, next_state;
    logic [4:0] fall_cnt;

    assign walk_left  = (state == S_WALK_L);
    assign walk_right = (state == S_WALK_R);
    assign aaah       = (state == S_FALL_L || state == S_FALL_R);
    assign digging    = (state == S_DIG_L || state == S_DIG_R);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WALK_L;
            fall_cnt <= 0;
        end else begin
            state <= next_state;
            if (state == S_FALL_L || state == S_FALL_R)
                fall_cnt <= (ground) ? 0 : (fall_cnt < 21 ? fall_cnt + 1 : 21);
            else
                fall_cnt <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_WALK_L: begin
                if (!ground) next_state = S_FALL_L;
                else if (dig) next_state = S_DIG_L;
                else if (bump_left) next_state = S_WALK_R;
            end
            S_WALK_R: begin
                if (!ground) next_state = S_FALL_R;
                else if (dig) next_state = S_DIG_R;
                else if (bump_right) next_state = S_WALK_L;
            end
            S_DIG_L: begin
                if (!ground) next_state = S_FALL_L;
            end
            S_DIG_R: begin
                if (!ground) next_state = S_FALL_R;
            end
            S_FALL_L: begin
                if (ground) next_state = (fall_cnt > 20) ? S_SPLAT : S_WALK_L;
            end
            S_FALL_R: begin
                if (ground) next_state = (fall_cnt > 20) ? S_SPLAT : S_WALK_R;
            end
            S_SPLAT: next_state = S_SPLAT;
        endcase
    end
endmodule