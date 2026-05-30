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

    localparam WALK_L = 3'd0, WALK_R = 3'd1, FALL_L = 3'd2, FALL_R = 3'd3, 
               DIG_L = 3'd4, DIG_R = 3'd5, SPLAT = 3'd6;

    logic [2:0] state, next_state;
    logic [7:0] fall_cnt;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WALK_L;
            fall_cnt <= 0;
        end else begin
            state <= next_state;
            if (next_state == FALL_L || next_state == FALL_R) begin
                if (!ground) fall_cnt <= fall_cnt + 1;
            end else begin
                fall_cnt <= 0;
            end
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
                if (ground) next_state = (fall_cnt > 20) ? SPLAT : WALK_L;
            end
            FALL_R: begin
                if (ground) next_state = (fall_cnt > 20) ? SPLAT : WALK_R;
            end
            SPLAT: next_state = SPLAT;
        endcase
    end

    assign walk_left = (state == WALK_L);
    assign walk_right = (state == WALK_R);
    assign aaah = (state == FALL_L || state == FALL_R);
    assign digging = (state == DIG_L || state == DIG_R);

endmodule
