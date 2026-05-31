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

    parameter WL = 3'd0, WR = 3'd1, FL = 3'd2, FR = 3'd3, DL = 3'd4, DR = 3'd5, SPLAT = 3'd6;

    logic [2:0] state, next_state;
    logic [5:0] fall_cnt; // Increase to 6 bits to safely cover 20+1

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_cnt <= 6'd0;
        end else begin
            state <= next_state;
            if (state == FL || state == FR) begin
                if (!ground) 
                    fall_cnt <= fall_cnt + 1'b1;
                else 
                    fall_cnt <= 6'd0;
            end else begin
                fall_cnt <= 6'd0;
            end
        end
    end

    always @(*) begin
        next_state = state;
        case (state)
            WL: begin
                if (!ground) next_state = FL;
                else if (dig) next_state = DL;
                else if (bump_left && bump_right) next_state = WR; // double bump logic check
                else if (bump_left) next_state = WR;
                else if (bump_right) next_state = WL; // stays WL if bump_right is true but it's already WL? Wait, specification says it switches direction.
                else next_state = WL;
            end
            WR: begin
                if (!ground) next_state = FR;
                else if (dig) next_state = DR;
                else if (bump_right && bump_left) next_state = WL;
                else if (bump_right) next_state = WL;
                else if (bump_left) next_state = WR;
                else next_state = WR;
            end
            FL: begin
                if (ground) next_state = (fall_cnt > 20) ? SPLAT : WL;
                else next_state = FL;
            end
            FR: begin
                if (ground) next_state = (fall_cnt > 20) ? SPLAT : WR;
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
            SPLAT: next_state = SPLAT;
            default: next_state = WL;
        endcase
    end

    assign walk_left = (state == WL);
    assign walk_right = (state == WR);
    assign aaah = (state == FL || state == FR);
    assign digging = (state == DL || state == DR);

endmodule
