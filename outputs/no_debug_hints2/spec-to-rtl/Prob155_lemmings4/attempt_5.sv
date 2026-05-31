module TopModule(
    input clk,
    input areset,
    input bump_left,
    input bump_right,
    input ground,
    input dig,
    output logic walk_left,
    output logic walk_right,
    output logic aaah,
    output logic digging
);

    logic [2:0] state, next_state;
    logic [5:0] fall_count;
    logic [5:0] next_fall_count;

    parameter WL = 3'd0, WR = 3'd1, FL = 3'd2, FR = 3'd3, DL = 3'd4, DR = 3'd5, SPLAT = 3'd6;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_count <= 6'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    always_comb begin
        next_state = state;
        next_fall_count = 6'd0;

        case (state)
            WL: begin
                if (!ground) next_state = FL;
                else if (dig) next_state = DL;
                else if (bump_right) next_state = WR;
                else if (bump_left) next_state = WR;
            end
            WR: begin
                if (!ground) next_state = FR;
                else if (dig) next_state = DR;
                else if (bump_left) next_state = WL;
                else if (bump_right) next_state = WL;
            end
            FL: begin
                if (ground) next_state = (fall_count > 6'd20) ? SPLAT : WL;
                else begin
                    next_state = FL;
                    next_fall_count = fall_count + 6'd1;
                end
            end
            FR: begin
                if (ground) next_state = (fall_count > 6'd20) ? SPLAT : WR;
                else begin
                    next_state = FR;
                    next_fall_count = fall_count + 6'd1;
                end
            end
            DL: begin
                if (!ground) next_state = FL;
            end
            DR: begin
                if (!ground) next_state = FR;
            end
            SPLAT: begin
                next_state = SPLAT;
            end
            default: next_state = WL;
        endcase
    end

    always_comb begin
        walk_left = (state == WL);
        walk_right = (state == WR);
        aaah = (state == FL || state == FR);
        digging = (state == DL || state == DR);
    end

endmodule
