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

    parameter LEFT = 0, RIGHT = 1, FALL_L = 2, FALL_R = 3, DIG_L = 4, DIG_R = 5, SPLAT = 6;
    
    logic [2:0] state, next_state;
    logic [6:0] fall_count;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
            fall_count <= 0;
        end else begin
            state <= next_state;
            if (next_state == FALL_L || next_state == FALL_R) begin
                if (state == FALL_L || state == FALL_R)
                    fall_count <= fall_count + 1;
                else
                    fall_count <= 1;
            end else
                fall_count <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            LEFT: begin
                if (!ground) next_state = FALL_L;
                else if (dig) next_state = DIG_L;
                else if (bump_left || bump_right) next_state = RIGHT;
            end
            RIGHT: begin
                if (!ground) next_state = FALL_R;
                else if (dig) next_state = DIG_R;
                else if (bump_right || bump_left) next_state = LEFT;
            end
            FALL_L: begin
                if (ground) next_state = (fall_count > 20) ? SPLAT : LEFT;
            end
            FALL_R: begin
                if (ground) next_state = (fall_count > 20) ? SPLAT : RIGHT;
            end
            DIG_L: begin
                if (!ground) next_state = FALL_L;
            end
            DIG_R: begin
                if (!ground) next_state = FALL_R;
            end
            SPLAT: next_state = SPLAT;
        endcase
    end

    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_L || state == FALL_R);
    assign digging = (state == DIG_L || state == DIG_R);

endmodule
