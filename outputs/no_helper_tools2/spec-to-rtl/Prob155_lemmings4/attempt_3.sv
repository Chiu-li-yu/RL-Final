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
        end else if (splat) begin
            state <= SPLAT;
        end else begin
            state <= next_state;
            if (next_state == FL_L || next_state == FL_R)
                fall_cnt <= (state == FL_L || state == FL_R) ? fall_cnt + 7'd1 : 7'd0;
            else
                fall_cnt <= 7'd0;
            
            if ((state == FL_L || state == FL_R) && ground && fall_cnt > 7'd20)
                splat <= 1'b1;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            WL: begin
                if (!ground) next_state = FL_L;
                else if (dig) next_state = DIG_L;
                else if (bump_left) next_state = WR;
            end
            WR: begin
                if (!ground) next_state = FL_R;
                else if (dig) next_state = DIG_R;
                else if (bump_right) next_state = WL;
            end
            FL_L: begin
                if (ground) next_state = WL;
            end
            FL_R: begin
                if (ground) next_state = WR;
            end
            DIG_L: begin
                if (!ground) next_state = FL_L;
            end
            DIG_R: begin
                if (!ground) next_state = FL_R;
            end
            SPLAT: next_state = SPLAT;
        endcase
    end

    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL_L || state == FL_R);
    assign digging = (state == DIG_L || state == DIG_R);

endmodule