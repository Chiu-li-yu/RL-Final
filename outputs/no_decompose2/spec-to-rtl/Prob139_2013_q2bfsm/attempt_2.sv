module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        A,
        INIT_F,
        WAIT_X1,
        WAIT_X0,
        WAIT_X1_2,
        CHECK_Y,
        WAIT_Y1,
        WAIT_Y2,
        G_PERM,
        G_ZERO
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    always_comb begin
        f = 0;
        g = 0;
        next_state = state;

        case (state)
            A: next_state = INIT_F;
            INIT_F: begin
                f = 1;
                next_state = WAIT_X1;
            end
            WAIT_X1: if (x) next_state = WAIT_X0;
            WAIT_X0: if (!x) next_state = WAIT_X1_2; else next_state = WAIT_X1;
            WAIT_X1_2: if (x) next_state = CHECK_Y; else next_state = WAIT_X1;
            CHECK_Y: begin
                // In CHECK_Y, g should be 1
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = WAIT_Y1;
            end
            WAIT_Y1: begin
                // Still in sequence, g=1
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = WAIT_Y2;
            end
            WAIT_Y2: begin
                // Still in sequence, g=1
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = G_ZERO;
            end
            G_PERM: g = 1;
            G_ZERO: g = 0;
        endcase
    end
endmodule
