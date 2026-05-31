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

    typedef enum logic [2:0] {
        WALK_L, WALK_R,
        DIG_L, DIG_R,
        FALL_L, FALL_R,
        SPLATTER
    } state_t;

    state_t state, next_state;
    logic [4:0] fall_cnt;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_cnt <= 0;
        end else begin
            state <= next_state;
            if (state == FALL_L || state == FALL_R)
                fall_cnt <= fall_cnt + 1'b1;
            else
                fall_cnt <= 0;
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
                if (ground) next_state = (fall_cnt > 20) ? SPLATTER : WALK_L;
            end
            FALL_R: begin
                if (ground) next_state = (fall_cnt > 20) ? SPLATTER : WALK_R;
            end
            SPLATTER: begin
                next_state = SPLATTER;
            end
        endcase
    end

    always @(*) begin
        walk_left = (state == WALK_L);
        walk_right = (state == WALK_R);
        aaah = (state == FALL_L || state == FALL_R);
        digging = (state == DIG_L || state == DIG_R);
    end

endmodule
