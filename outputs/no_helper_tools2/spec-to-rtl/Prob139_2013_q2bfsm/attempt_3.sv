module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        S_A, S_F1, S_IDLE, S_X1, S_X10, S_G1
    } state_t;

    state_t state, next_state;
    logic g_state; // 0: g=0, 1: g=1
    logic g_perm;  // 0: monitor, 1: locked

    always @(posedge clk) begin
        if (!resetn) begin
            state <= S_A;
            g_state <= 0;
            g_perm <= 0;
        end else begin
            state <= next_state;
            if (state == S_X10 && x) g_state <= 1;
            if (g_state && !g_perm) begin
                // Monitor y for up to 2 cycles
                // Actually the state machine approach was cleaner.
            end
        end
    end
    // The previous state machine logic was conceptually correct for 1-0-1 sequence.
    // Let's re-verify the "g=1" timing. "When x=1,0,1, then g should be set to 1 on the FOLLOWING clock cycle."
endmodule
