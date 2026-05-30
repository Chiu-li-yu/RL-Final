module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        STATE_A,
        STATE_INIT_F,
        STATE_MONITOR_X_1,
        STATE_MONITOR_X_0,
        STATE_MONITOR_X_1_FINAL,
        STATE_MONITOR_Y_1,
        STATE_MONITOR_Y_2,
        STATE_HOLD_G,
        STATE_RESET_G
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: begin
                next_state = STATE_INIT_F;
            end
            STATE_INIT_F: begin
                f = 1;
                next_state = STATE_MONITOR_X_1;
            end
            STATE_MONITOR_X_1: begin
                if (x) next_state = STATE_MONITOR_X_0;
            end
            STATE_MONITOR_X_0: begin
                if (!x) next_state = STATE_MONITOR_X_1_FINAL;
                else if (x) next_state = STATE_MONITOR_X_0;
            end
            STATE_MONITOR_X_1_FINAL: begin
                if (x) next_state = STATE_MONITOR_Y_1;
                else next_state = STATE_MONITOR_X_1;
            end
            STATE_MONITOR_Y_1: begin
                g = 1;
                if (y) next_state = STATE_HOLD_G;
                else next_state = STATE_MONITOR_Y_2;
            end
            STATE_MONITOR_Y_2: begin
                g = 1;
                if (y) next_state = STATE_HOLD_G;
                else next_state = STATE_RESET_G;
            end
            STATE_HOLD_G: begin
                g = 1;
            end
            STATE_RESET_G: begin
                g = 0;
            end
            default: next_state = STATE_A;
        endcase
    end

endmodule