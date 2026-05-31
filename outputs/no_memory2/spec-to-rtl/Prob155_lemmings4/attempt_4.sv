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

    parameter LEFT = 0, RIGHT = 1, FALL_L = 2, FALL_R = 3, DIG_L = 4, DIG_R = 5, SPLAT = 6;

    logic [2:0] state, next_state;
    logic [5:0] fall_cnt;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= LEFT;
            fall_cnt <= 0;
        end else begin
            state <= next_state;
            if (state == FALL_L || state == FALL_R)
                fall_cnt <= fall_cnt + 1;
            else
                fall_cnt <= 0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            LEFT: begin
                if (!ground) next_state = FALL_L;
                else if (dig) next_state = DIG_L;
                else if (bump_left && bump_right) next_state = RIGHT;
                else if (bump_left) next_state = RIGHT;
                else if (bump_right) next_state = LEFT;
            end
            RIGHT: begin
                if (!ground) next_state = FALL_R;
                else if (dig) next_state = DIG_R;
                else if (bump_left && bump_right) next_state = LEFT;
                else if (bump_right) next_state = LEFT;
                else if (bump_left) next_state = RIGHT;
            end
            FALL_L: begin
                if (ground) next_state = (fall_cnt > 20) ? SPLAT : LEFT;
            end
            FALL_R: begin
                if (ground) next_state = (fall_cnt > 20) ? SPLAT : RIGHT;
            end
            DIG_L: begin
                if (!ground) next_state = FALL_L;
            end
            DIG_R: begin
                if (!ground) next_state = FALL_R;
            end
            SPLAT: begin
                next_state = SPLAT;
            end
        endcase
    end

    assign walk_left = (state == LEFT);
    assign walk_right = (state == RIGHT);
    assign aaah = (state == FALL_L || state == FALL_R);
    assign digging = (state == DIG_L || state == DIG_R);

endmodule