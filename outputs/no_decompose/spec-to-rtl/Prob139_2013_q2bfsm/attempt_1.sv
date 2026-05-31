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
        STATE_START,
        STATE_X1,
        STATE_X10,
        STATE_X101,
        STATE_G1_WAIT1,
        STATE_G1_WAIT2,
        STATE_G1_PERM,
        STATE_G0_PERM
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn)
            state <= STATE_A;
        else
            state <= next_state;
    end

    always_comb begin
        next_state = state;
        f = 0;
        g = 0;

        case (state)
            STATE_A: next_state = STATE_START;
            STATE_START: begin
                f = 1;
                next_state = STATE_X1;
            end
            STATE_X1: begin
                if (x) next_state = STATE_X10;
                else next_state = STATE_X1;
            end
            STATE_X10: begin
                if (!x) next_state = STATE_X101;
                else next_state = STATE_X1;
            end
            STATE_X101: begin
                if (x) next_state = STATE_G1_WAIT1;
                else next_state = STATE_X1;
            end
            STATE_G1_WAIT1: begin
                g = 1;
                if (y) next_state = STATE_G1_PERM;
                else next_state = STATE_G1_WAIT2;
            end
            STATE_G1_WAIT2: begin
                g = 1;
                if (y) next_state = STATE_G1_PERM;
                else next_state = STATE_G0_PERM;
            end
            STATE_G1_PERM: begin
                g = 1;
            end
            STATE_G0_PERM: begin
                g = 0;
            end
        endcase
    end
endmodule
