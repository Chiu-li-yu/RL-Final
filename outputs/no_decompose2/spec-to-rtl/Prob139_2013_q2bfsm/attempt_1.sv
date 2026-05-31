module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        A,          // Reset state
        INIT_F,     // f=1 for one cycle
        WAIT_X1,    // Expect x=1
        WAIT_X0,    // Expect x=0
        WAIT_X1_2,  // Expect x=1
        CHECK_Y,    // g=1, monitor y
        WAIT_Y1,    // y not 1 yet
        WAIT_Y2,    // y not 1 yet
        G_PERM,     // g=1 permanently
        G_ZERO      // g=0 permanently
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
            WAIT_X0: if (!x) next_state = WAIT_X1_2; else if (x) next_state = WAIT_X1;
            WAIT_X1_2: if (x) next_state = CHECK_Y; else next_state = WAIT_X1;
            CHECK_Y: begin
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = WAIT_Y1;
            end
            WAIT_Y1: begin
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = WAIT_Y2;
            end
            WAIT_Y2: begin
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = G_ZERO;
            end
            G_PERM: g = 1;
            G_ZERO: g = 0;
        endcase
    end
endmodule
