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

    typedef enum logic [3:0] {
        WL, WR, FL, FR, DL, DR, SP
    } state_t;

    state_t state, next_state;
    logic [5:0] cnt;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            cnt <= 6'b0;
        end else begin
            state <= next_state;
            if (next_state == FL || next_state == FR)
                cnt <= (state == FL || state == FR) ? cnt + 1'b1 : 1'b1;
            else
                cnt <= 6'b0;
        end
    end

    always_comb begin
        next_state = state;
        case (state)
            WL: begin
                if (!ground) next_state = FL;
                else if (dig) next_state = DL;
                else if (bump_left) next_state = WR;
            end
            WR: begin
                if (!ground) next_state = FR;
                else if (dig) next_state = DR;
                else if (bump_right) next_state = WL;
            end
            FL: if (ground) next_state = (cnt > 20) ? SP : WL;
            FR: if (ground) next_state = (cnt > 20) ? SP : WR;
            DL: if (!ground) next_state = FL;
            DR: if (!ground) next_state = FR;
            SP: next_state = SP;
        endcase
    end

    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule
