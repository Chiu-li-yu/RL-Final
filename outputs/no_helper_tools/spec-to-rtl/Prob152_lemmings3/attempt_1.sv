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

    parameter WL = 3'd0, WR = 3'd1, FL = 3'd2, FR = 3'd3, DL = 3'd4, DR = 3'd5;
    logic [2:0] state, next_state;

    always_ff @(posedge clk or posedge areset) begin
        if (areset)
            state <= WL;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            WL: begin
                if (!ground) next_state = FL;
                else if (dig) next_state = DL;
                else if (bump_left) next_state = WR;
                else next_state = WL;
            end
            WR: begin
                if (!ground) next_state = FR;
                else if (dig) next_state = DR;
                else if (bump_right) next_state = WL;
                else next_state = WR;
            end
            FL: begin
                if (ground) next_state = WL;
                else next_state = FL;
            end
            FR: begin
                if (ground) next_state = WR;
                else next_state = FR;
            end
            DL: begin
                if (!ground) next_state = FL;
                else next_state = DL;
            end
            DR: begin
                if (!ground) next_state = FR;
                else next_state = DR;
            end
            default: next_state = WL;
        endcase
    end

    assign walk_left = (state == WL || state == DL);
    assign walk_right = (state == WR || state == DR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule
