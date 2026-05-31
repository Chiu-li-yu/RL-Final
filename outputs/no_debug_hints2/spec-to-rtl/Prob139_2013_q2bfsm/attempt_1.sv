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
        STATE_INIT,
        STATE_MONITOR_X_INIT,
        STATE_MONITOR_X_1,
        STATE_MONITOR_X_10,
        STATE_G_HIGH,
        STATE_MONITOR_Y_1,
        STATE_MONITOR_Y_2,
        STATE_G_PERMANENT,
        STATE_G_ZERO
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (!resetn) state <= STATE_A;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: begin
                next_state = STATE_INIT;
            end
            STATE_INIT: begin
                f = 1;
                next_state = STATE_MONITOR_X_INIT;
            end
            STATE_MONITOR_X_INIT: begin
                if (x == 1) next_state = STATE_MONITOR_X_1;
            end
            STATE_MONITOR_X_1: begin
                if (x == 0) next_state = STATE_MONITOR_X_10;
                else if (x == 1) next_state = STATE_MONITOR_X_1;
                else next_state = STATE_MONITOR_X_INIT;
            end
            STATE_MONITOR_X_10: begin
                if (x == 1) next_state = STATE_G_HIGH;
                else if (x == 0) next_state = STATE_MONITOR_X_INIT;
                else next_state = STATE_MONITOR_X_INIT;
            end
            STATE_G_HIGH: begin
                g = 1;
                next_state = STATE_MONITOR_Y_1;
            end
            STATE_MONITOR_Y_1: begin
                g = 1;
                if (y == 1) next_state = STATE_G_PERMANENT;
                else next_state = STATE_MONITOR_Y_2;
            end
            STATE_MONITOR_Y_2: begin
                g = 1;
                if (y == 1) next_state = STATE_G_PERMANENT;
                else next_state = STATE_G_ZERO;
            end
            STATE_G_PERMANENT: begin
                g = 1;
            end
            STATE_G_ZERO: begin
                g = 0;
            end
        endcase
    end
endmodule
