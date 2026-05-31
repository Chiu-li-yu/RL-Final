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

    parameter WL = 3'd0, WR = 3'd1, FL = 3'd2, FR = 3'd3, DL = 3'd4, DR = 3'd5, S = 3'd6;

    logic [2:0] state, next_state;
    logic [5:0] fall_count;
    logic fall_timeout;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_count <= 6'd0;
        end else begin
            state <= next_state;
            if (state == FL || state == FR)
                fall_count <= fall_count + 1'b1;
            else
                fall_count <= 6'd0;
        end
    end

    assign fall_timeout = (fall_count > 6'd20);

    always @(*) begin
        next_state = state;
        case (state)
            WL: begin
                if (!ground) next_state = FL;
                else if (dig) next_state = DL;
                else if (bump_right) next_state = WR;
            end
            WR: begin
                if (!ground) next_state = FR;
                else if (dig) next_state = DR;
                else if (bump_left) next_state = WL;
            end
            FL: begin
                if (ground) next_state = fall_timeout ? S : WL;
            end
            FR: begin
                if (ground) next_state = fall_timeout ? S : WR;
            end
            DL: begin
                if (!ground) next_state = FL;
            end
            DR: begin
                if (!ground) next_state = FR;
            end
            S: next_state = S;
            default: next_state = WL;
        endcase
    end

    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule