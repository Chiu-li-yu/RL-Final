
module TopModule (
    input  clk,
    input  areset,
    input  bump_left,
    input  bump_right,
    input  ground,
    input  dig,
    output walk_left,
    output walk_right,
    output aaah,
    output digging
);

    localparam S_WL = 3'd0,
               S_WR = 3'd1,
               S_F_L = 3'd2,
               S_F_R = 3'd3,
               S_DL = 3'd4,
               S_DR = 3'd5;

    logic [2:0] state, next_state;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= S_WL;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            S_WL: begin
                if (!ground)
                    next_state = S_F_L;
                else if (dig)
                    next_state = S_DL;
                else if (bump_left)
                    next_state = S_WR;
                else
                    next_state = S_WL;
            end
            S_WR: begin
                if (!ground)
                    next_state = S_F_R;
                else if (dig)
                    next_state = S_DR;
                else if (bump_right)
                    next_state = S_WL;
                else
                    next_state = S_WR;
            end
            S_F_L: begin
                if (ground)
                    next_state = S_WL;
                else
                    next_state = S_F_L;
            end
            S_F_R: begin
                if (ground)
                    next_state = S_WR;
                else
                    next_state = S_F_R;
            end
            S_DL: begin
                if (!ground)
                    next_state = S_F_L;
                else
                    next_state = S_DL;
            end
            S_DR: begin
                if (!ground)
                    next_state = S_F_R;
                else
                    next_state = S_DR;
            end
            default: next_state = S_WL;
        endcase
    end

    assign walk_left  = (state == S_WL);
    assign walk_right = (state == S_WR);
    assign aaah       = (state == S_F_L || state == S_F_R);
    assign digging    = (state == S_DL || state == S_DR);

endmodule
