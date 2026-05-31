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

    typedef enum logic [2:0] {WL, WR, FL_L, FL_R, DIG_L, DIG_R, SPLAT} state_t;
    state_t state, next_state;
    logic [6:0] fall_cnt;
    logic splat;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_cnt <= 7'd0;
            splat <= 1'b0;
        end else begin
            if (state == SPLAT) begin
                state <= SPLAT;
            end else begin
                state <= next_state;
            end

            if (next_state == FL_L || next_state == FL_R) begin
                fall_cnt <= (state == FL_L || state == FL_R) ? fall_cnt + 7'd1 : 7'd0;
            end else begin
                fall_cnt <= 7'd0;
            end

            if ((state == FL_L || state == FL_R) && ground && (fall_cnt > 7'd20)) begin
                splat <= 1'b1;
            end
        end
    end

    always @(*) begin
        next_state = state;
        if (state == SPLAT) next_state = SPLAT;
        else if (!ground) begin
            next_state = (state == WR || state == DIG_R) ? FL_R : FL_L;
        end else begin
            case (state)
                WL: begin
                    if (dig) next_state = DIG_L;
                    else if (bump_left) next_state = WR;
                end
                WR: begin
                    if (dig) next_state = DIG_R;
                    else if (bump_right) next_state = WL;
                end
                FL_L: next_state = WL;
                FL_R: next_state = WR;
                DIG_L: begin end
                DIG_R: begin end
            endcase
        end
    end

    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL_L || state == FL_R);
    assign digging = (state == DIG_L || state == DIG_R);

endmodule