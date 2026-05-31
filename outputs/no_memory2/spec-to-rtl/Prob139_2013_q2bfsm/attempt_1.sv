module TopModule (
    input logic clk,
    input logic resetn,
    input logic x,
    input logic y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        STATE_A,
        STATE_F_HIGH,
        STATE_WAIT_1,
        STATE_WAIT_0,
        STATE_WAIT_1_FINAL,
        STATE_G_HIGH,
        STATE_MONITOR_Y_1,
        STATE_MONITOR_Y_2,
        STATE_G_PERM,
        STATE_G_ZERO
    } state_t;

    state_t state, next_state;
    logic [1:0] y_timer;

    always @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            y_timer <= 2'b0;
        end else begin
            state <= next_state;
            if (state == STATE_G_HIGH) y_timer <= 2'b0;
            else if (state == STATE_MONITOR_Y_1 || state == STATE_MONITOR_Y_2) y_timer <= y_timer + 1;
        end
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: next_state = STATE_F_HIGH;
            STATE_F_HIGH: begin
                f = 1;
                next_state = STATE_WAIT_1;
            end
            STATE_WAIT_1: if (x) next_state = STATE_WAIT_0;
            STATE_WAIT_0: if (!x) next_state = STATE_WAIT_1_FINAL; else if (x) next_state = STATE_WAIT_1; else next_state = STATE_WAIT_1;
            STATE_WAIT_1_FINAL: if (x) next_state = STATE_G_HIGH; else next_state = STATE_WAIT_1;
            STATE_G_HIGH: begin
                g = 1;
                next_state = STATE_MONITOR_Y_1;
            end
            STATE_MONITOR_Y_1: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else next_state = STATE_MONITOR_Y_2;
            end
            STATE_MONITOR_Y_2: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else next_state = STATE_G_ZERO;
            end
            STATE_G_PERM: g = 1;
            STATE_G_ZERO: g = 0;
            default: next_state = STATE_A;
        endcase
    end
endmodule
