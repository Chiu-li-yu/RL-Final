module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    // Using Moore FSM states
    typedef enum logic [3:0] {
        A,
        F1,
        X1,
        X0,
        X1_2,
        G1,
        G1_Y1,
        G1_Y2,
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
            A: next_state = F1;
            F1: begin
                f = 1;
                next_state = X1;
            end
            X1: if (x) next_state = X0;
            X0: if (!x) next_state = X1_2; else next_state = X1;
            X1_2: if (x) next_state = G1; else next_state = X1;
            G1: begin
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = G1_Y1;
            end
            G1_Y1: begin
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = G1_Y2;
            end
            G1_Y2: begin
                g = 1;
                if (y) next_state = G_PERM;
                else next_state = G_ZERO;
            end
            G_PERM: g = 1;
            G_ZERO: g = 0;
        endcase
    end
endmodule
