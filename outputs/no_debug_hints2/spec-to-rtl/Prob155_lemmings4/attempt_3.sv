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

    typedef enum logic [2:0] {
        WL = 3'd0, WR = 3'd1, FL = 3'd2, FR = 3'd3, DL = 3'd4, DR = 3'd5, SPLAT = 3'd6
    } state_t;

    state_t state, next_state;
    logic [4:0] fall_count;
    logic [4:0] next_fall_count;

    always_ff @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= WL;
            fall_count <= 5'd0;
        end else begin
            state <= next_state;
            fall_count <= next_fall_count;
        end
    end

    always_comb begin
        next_state = state;
        next_fall_count = fall_count;

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
                if (ground) next_state = (fall_count > 5'd20) ? SPLAT : WL;
                else next_fall_count = fall_count + 5'd1;
            end
            FR: begin
                if (ground) next_state = (fall_count > 5'd20) ? SPLAT : WR;
                else next_fall_count = fall_count + 5'd1;
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
        endcase
    end

    always_comb begin
        walk_left = (state == WL);
        walk_right = (state == WR);
        aaah = (state == FL || state == FR);
        digging = (state == DL || state == DR);
    end

endmodule
