module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);
    typedef enum logic [3:0] {
        S_RESET, S_F, S_WAIT1, S_WAIT0, S_WAIT1_FINAL, S_G_SET, S_MONITOR_Y1, S_MONITOR_Y2, S_GO, S_STOP
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (!resetn) state <= S_RESET;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            S_RESET: next_state = S_F;
            S_F: begin
                f = 1;
                next_state = S_WAIT1;
            end
            S_WAIT1: if (x) next_state = S_WAIT0;
            S_WAIT0: if (!x) next_state = S_WAIT1_FINAL; else next_state = S_WAIT0;
            S_WAIT1_FINAL: if (x) next_state = S_G_SET; else next_state = S_RESET; // 更正：重啟序列
            S_G_SET: begin
                g = 1;
                next_state = S_MONITOR_Y1;
            end
            S_MONITOR_Y1: begin
                g = 1;
                if (y) next_state = S_GO;
                else next_state = S_MONITOR_Y2;
            end
            S_MONITOR_Y2: begin
                g = 1;
                if (y) next_state = S_GO;
                else next_state = S_STOP;
            end
            S_GO: g = 1;
            S_STOP: g = 0;
            default: next_state = S_RESET;
        endcase
    end
endmodule
