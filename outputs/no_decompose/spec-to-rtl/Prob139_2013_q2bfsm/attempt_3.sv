module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        S_A, S_START, S_X1, S_X10, S_X101, S_G1, S_WAIT_Y1, S_WAIT_Y2, S_G_PERM1, S_G_PERM0
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn) state <= S_A;
        else state <= next_state;
    end

    always_comb begin
        next_state = state;
        f = 0;
        g = 0;
        case (state)
            S_A: next_state = S_START;
            S_START: begin
                f = 1;
                next_state = S_X1;
            end
            S_X1: begin
                if (x) next_state = S_X10;
            end
            S_X10: begin
                if (!x) next_state = S_X101;
                else if (x) next_state = S_X1;
            end
            S_X101: begin
                if (x) next_state = S_G1;
                else next_state = S_X1;
            end
            S_G1: begin
                g = 1;
                if (y) next_state = S_G_PERM1;
                else next_state = S_WAIT_Y1;
            end
            S_WAIT_Y1: begin
                g = 1;
                if (y) next_state = S_G_PERM1;
                else next_state = S_WAIT_Y2;
            end
            S_WAIT_Y2: begin
                g = 1;
                if (y) next_state = S_G_PERM1;
                else next_state = S_G_PERM0;
            end
            S_G_PERM1: begin
                g = 1;
            end
            S_G_PERM0: begin
                g = 0;
            end
        endcase
    end
endmodule
