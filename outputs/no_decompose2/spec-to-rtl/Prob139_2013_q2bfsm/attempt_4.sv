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
        F_HIGH,
        WAIT_X1,
        WAIT_X0,
        WAIT_X1_2,
        CHECK_G,
        G_HIGH_1,
        G_HIGH_2,
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
            A: next_state = F_HIGH;
            F_HIGH: begin
                f = 1;
                next_state = WAIT_X1;
            end
            WAIT_X1: if (x) next_state = WAIT_X0;
            WAIT_X0: if (!x) next_state = WAIT_X1_2; else next_state = WAIT_X1;
            WAIT_X1_2: if (x) next_state = CHECK_G; else next_state = WAIT_X1;
            CHECK_G: begin
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = G_HIGH_1;
            end
            G_HIGH_1: begin
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = G_HIGH_2;
            end
            G_HIGH_2: begin
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = G_ZERO;
            end
            G_PERM: g = 1;
            G_ZERO: g = 0;
        endcase
    end
endmodule
