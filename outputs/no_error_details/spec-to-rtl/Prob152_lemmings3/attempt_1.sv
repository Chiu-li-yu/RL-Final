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

    parameter WL = 0, WR = 1, FL = 2, FR = 3, DL = 4, DR = 5;
    logic [2:0] state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WL;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
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

    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule