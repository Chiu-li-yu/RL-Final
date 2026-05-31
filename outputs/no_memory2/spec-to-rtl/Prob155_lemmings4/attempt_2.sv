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

    parameter WL = 0, WR = 1, FL = 2, FR = 3, DL = 4, DR = 5, S = 6;

    logic [2:0] state, next_state;
    logic [5:0] fall_cnt;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_cnt <= 0;
        end else begin
            state <= next_state;
            if (state == FL || state == FR)
                fall_cnt <= fall_cnt + 1;
            else
                fall_cnt <= 0;
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
            FL: begin
                if (ground) begin
                    if (fall_cnt > 20) next_state = S;
                    else next_state = WL;
                end
            end
            FR: begin
                if (ground) begin
                    if (fall_cnt > 20) next_state = S;
                    else next_state = WR;
                end
            end
            DL: begin
                if (!ground) next_state = FL;
            end
            DR: begin
                if (!ground) next_state = FR;
            end
            S: begin
                next_state = S;
            end
        endcase
    end

    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule
