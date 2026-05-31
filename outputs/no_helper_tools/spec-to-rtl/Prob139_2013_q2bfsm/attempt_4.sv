module TopModule (
    input logic clk,
    input logic resetn,
    input logic x,
    input logic y,
    output logic f,
    output logic g
);

    typedef enum logic [3:0] {
        S_A, S_F, S_W1, S_W0, S_W1F, S_G, S_MON1, S_MON2, S_GK, S_GO
    } state_t;

    state_t state, next_state;

    always_ff @(posedge clk) begin
        if (!resetn) state <= S_A;
        else state <= next_state;
    end

    always @(*) begin
        next_state = state;
        f = 0;
        g = 0;
        case (state)
            S_A: next_state = S_F;
            S_F: begin
                f = 1;
                next_state = S_W1;
            end
            S_W1: if (x) next_state = S_W0;
            S_W0: if (!x) next_state = S_W1F; else next_state = S_W1;
            S_W1F: if (x) next_state = S_G; else next_state = S_W1;
            S_G: begin
                g = 1;
                next_state = y ? S_GK : S_MON1;
            end
            S_MON1: begin
                g = 1;
                next_state = y ? S_GK : S_MON2;
            end
            S_MON2: begin
                g = 1;
                next_state = y ? S_GK : S_GO;
            end
            S_GK: g = 1;
            S_GO: g = 0;
            default: next_state = S_A;
        endcase
    end
endmodule
