module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        STATE_A,    // Reset state
        STATE_F1,   // Set f=1 for one cycle
        STATE_IDLE, // Monitor x for 1, 0, 1
        STATE_X1,   // Found first '1'
        STATE_X10,  // Found '1', '0'
        STATE_G1,   // g=1, monitor y
        STATE_Y_WAIT1, // Monitor y first cycle
        STATE_Y_WAIT2, // Monitor y second cycle
        STATE_G_PERM,  // y=1, g=1 permanent
        STATE_G_OFF    // y=0 after 2 cycles, g=0 permanent
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (!resetn)
            state <= STATE_A;
        else
            state <= next_state;
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: begin
                next_state = STATE_F1;
            end
            STATE_F1: begin
                f = 1;
                next_state = STATE_IDLE;
            end
            STATE_IDLE: begin
                if (x) next_state = STATE_X1;
            end
            STATE_X1: begin
                if (!x) next_state = STATE_X10;
                else next_state = STATE_X1;
            end
            STATE_X10: begin
                if (x) next_state = STATE_G1;
                else next_state = STATE_IDLE;
            end
            STATE_G1: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else next_state = STATE_Y_WAIT1;
            end
            STATE_Y_WAIT1: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else next_state = STATE_Y_WAIT2;
            end
            STATE_Y_WAIT2: begin
                g = 1;
                if (y) next_state = STATE_G_PERM;
                else next_state = STATE_G_OFF;
            end
            STATE_G_PERM: begin
                g = 1;
            end
            STATE_G_OFF: begin
                g = 0;
            end
        endcase
    end
endmodule
