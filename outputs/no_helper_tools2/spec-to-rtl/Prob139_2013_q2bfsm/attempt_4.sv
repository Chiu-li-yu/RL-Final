module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);
    // State machine to handle the sequence and timing
    typedef enum logic [3:0] {
        A, F1, IDLE, X1, X10, G1, Y1, Y2, G_PERM, G_OFF
    } state_t;

    state_t state, next_state;

    always @(posedge clk) begin
        if (!resetn) state <= A;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;
        case (state)
            A: next_state = F1;
            F1: begin f = 1; next_state = IDLE; end
            IDLE: if (x) next_state = X1;
            X1: if (x) next_state = X1; else next_state = X10;
            X10: if (x) next_state = G1; else next_state = IDLE;
            G1: begin g = 1; if (y) next_state = G_PERM; else next_state = Y1; end
            Y1: begin g = 1; if (y) next_state = G_PERM; else next_state = Y2; end
            Y2: begin g = 1; if (y) next_state = G_PERM; else next_state = G_OFF; end
            G_PERM: g = 1;
            G_OFF: g = 0;
        endcase
    end
endmodule
