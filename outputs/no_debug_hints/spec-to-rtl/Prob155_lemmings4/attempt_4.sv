module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

    parameter WALK_L = 3'd0, WALK_R = 3'd1, DIG_L = 3'd2, DIG_R = 3'd3, FALL_L = 3'd4, FALL_R = 3'd5, SPLATTER = 3'd6;

    logic [2:0] state, next_state;
    logic [5:0] fall_cnt;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_cnt <= 6'b0;
        end else begin
            state <= next_state;
            if (state == FALL_L || state == FALL_R)
                fall_cnt <= fall_cnt + 6'd1;
            else
                fall_cnt <= 6'b0;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            WALK_L: begin
                if (!ground) next_state = FALL_L;
                else if (dig) next_state = DIG_L;
                else if (bump_left) next_state = WALK_R;
            end
            WALK_R: begin
                if (!ground) next_state = FALL_R;
                else if (dig) next_state = DIG_R;
                else if (bump_right) next_state = WALK_L;
            end
            DIG_L: begin
                if (!ground) next_state = FALL_L;
            end
            DIG_R: begin
                if (!ground) next_state = FALL_R;
            end
            FALL_L: begin
                if (ground) next_state = (fall_cnt > 6'd20) ? SPLATTER : WALK_L;
            end
            FALL_R: begin
                if (ground) next_state = (fall_cnt > 6'd20) ? SPLATTER : WALK_R;
            end
            SPLATTER: begin
                next_state = SPLATTER;
            end
            default: next_state = WALK_L;
        endcase
    end

    always @(*) begin
        walk_left = (state == WALK_L);
        walk_right = (state == WALK_R);
        aaah = (state == FALL_L || state == FALL_R);
        digging = (state == DIG_L || state == DIG_R);
    end

endmodule
