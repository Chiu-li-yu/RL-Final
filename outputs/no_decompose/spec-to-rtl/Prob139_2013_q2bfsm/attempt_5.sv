module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        S_A, S_START, S_X1, S_X10, S_X101, S_G1, S_PERM1, S_PERM0
    } state_t;

    state_t state, next_state;
    logic [1:0] timer;

    always_ff @(posedge clk) begin
        if (!resetn) begin
            state <= S_A;
            timer <= 0;
        end else begin
            state <= next_state;
            if (state == S_G1) timer <= 0;
            else if (state == S_G1 || state == S_PERM1 || state == S_PERM0) timer <= timer;
            else timer <= timer + 1'b1;
        end
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
            S_X1: if (x) next_state = S_X10;
            S_X10: if (!x) next_state = S_X101; else if (x) next_state = S_X1;
            S_X101: if (x) next_state = S_G1; else next_state = S_X1;
            S_G1: begin
                g = 1;
                if (y) next_state = S_PERM1;
                else if (timer >= 2) next_state = S_PERM0;
            end
            S_PERM1: g = 1;
            S_PERM0: g = 0;
        endcase
    end
endmodule
