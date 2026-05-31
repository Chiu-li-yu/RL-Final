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

    parameter S_WALK_LEFT = 3'd0;
    parameter S_WALK_RIGHT = 3'd1;
    parameter S_FALL_LEFT = 3'd2;
    parameter S_FALL_RIGHT = 3'd3;
    parameter S_DIG_LEFT = 3'd4;
    parameter S_DIG_RIGHT = 3'd5;

    logic [2:0] state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) state <= S_WALK_LEFT;
        else state <= next_state;
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
                if (ground) next_state = S_WALK_LEFT;
            end
            S_FALL_RIGHT: begin
                if (ground) next_state = S_WALK_RIGHT;
            end
            S_DIG_LEFT: begin
                if (!ground) next_state = S_FALL_LEFT;
            end
            S_DIG_RIGHT: begin
                if (!ground) next_state = S_FALL_RIGHT;
            end
        endcase
    end

    assign walk_left = (state == S_WALK_LEFT);
    assign walk_right = (state == S_WALK_RIGHT);
    assign aaah = (state == S_FALL_LEFT || state == S_FALL_RIGHT);
    assign digging = (state == S_DIG_LEFT || state == S_DIG_RIGHT);

endmodule
