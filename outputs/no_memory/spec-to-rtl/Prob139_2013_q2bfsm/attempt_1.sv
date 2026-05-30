module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);
    typedef enum logic [3:0] {
        STATE_A,
        STATE_F_HIGH,
        STATE_DETECT_1,
        STATE_DETECT_10,
        STATE_DETECT_101,
        STATE_MONITOR_G1,
        STATE_MONITOR_Y,
        STATE_MONITOR_Y_WAIT,
        STATE_G_PERM_1,
        STATE_G_PERM_0
    } state_t;

    state_t state, next_state;
    logic [1:0] monitor_count;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= STATE_A;
            monitor_count <= 0;
        end else begin
            state <= next_state;
            if (state == STATE_MONITOR_Y || state == STATE_MONITOR_Y_WAIT)
                monitor_count <= monitor_count + 1;
            else
                monitor_count <= 0;
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
                next_state = STATE_DETECT_1;
            end
            STATE_DETECT_1: begin
                if (x) next_state = STATE_DETECT_10;
            end
            STATE_DETECT_10: begin
                if (!x) next_state = STATE_DETECT_101;
                else if (x) next_state = STATE_DETECT_10;
                else next_state = STATE_DETECT_1;
            end
            STATE_DETECT_101: begin
                if (x) next_state = STATE_MONITOR_G1;
                else next_state = STATE_DETECT_1;
            end
            STATE_MONITOR_G1: begin
                g = 1;
                next_state = STATE_MONITOR_Y;
            end
            STATE_MONITOR_Y: begin
                g = 1;
                if (y) next_state = STATE_G_PERM_1;
                else next_state = STATE_MONITOR_Y_WAIT;
            end
            STATE_MONITOR_Y_WAIT: begin
                g = 1;
                if (y) next_state = STATE_G_PERM_1;
                else next_state = STATE_G_PERM_0;
            end
            STATE_G_PERM_1: begin
                g = 1;
                next_state = STATE_G_PERM_1;
            end
            STATE_G_PERM_0: begin
                g = 0;
                next_state = STATE_G_PERM_0;
            end
            default: next_state = STATE_A;
        endcase
    end
endmodule