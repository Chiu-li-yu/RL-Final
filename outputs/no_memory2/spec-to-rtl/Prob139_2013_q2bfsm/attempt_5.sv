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
        STATE_F,
        STATE_X1,
        STATE_X0,
        STATE_X1_DETECTED,
        STATE_G_HIGH,
        STATE_Y_MONITOR,
        STATE_G_PERM,
        STATE_G_ZERO
    } state_t;

    state_t state, next_state;
    logic [1:0] y_count;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            y_count <= 0;
        end else begin
            state <= next_state;
            if (state == STATE_G_HIGH || state == STATE_Y_MONITOR) begin
                y_count <= y_count + 1;
            end else begin
                y_count <= 0;
            end
        end
    end

    always_comb begin
        next_state = state;
        f = 0;
        g = 0;
        case (state)
            STATE_A: next_state = STATE_F;
            STATE_F: begin
                f = 1;
                next_state = STATE_X1;
            end
            STATE_X1: if (x) next_state = STATE_X0;
            STATE_X0: if (!x) next_state = STATE_X1_DETECTED; else next_state = STATE_X1;
            STATE_X1_DETECTED: if (x) next_state = STATE_G_HIGH; else next_state = STATE_X1;
            STATE_G_HIGH: begin
                g = 1;
                next_state = STATE_Y_MONITOR;
            end
            STATE_Y_MONITOR: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else if (y_count == 2) next_state = STATE_G_ZERO;
            end
            STATE_G_PERM: g = 1;
            STATE_G_ZERO: g = 0;
        endcase
    end
endmodule
