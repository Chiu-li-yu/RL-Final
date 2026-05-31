module TopModule (
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    output walk_left,
    output walk_right,
    output aaah
);

    parameter WL = 2'b00, WR = 2'b01, FL = 2'b10, FR = 2'b11;

    logic [1:0] state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= WL;
        else
            state <= next_state;
    end

    always @(*) begin
        case (state)
            WL: begin
                if (!ground) next_state = FL;
                else if (bump_left && bump_right) next_state = WR;
                else if (bump_left) next_state = WR;
                else if (bump_right) next_state = WL;
                else next_state = WL;
            end
            WR: begin
                if (!ground) next_state = FR;
                else if (bump_left && bump_right) next_state = WL;
                else if (bump_left) next_state = WR;
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
            default: next_state = WL;
        endcase
    end

    assign walk_left  = (state == WL || state == FL);
    assign walk_right = (state == WR || state == FR);
    assign aaah       = (state == FL || state == FR);

endmodule
