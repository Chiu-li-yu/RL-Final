module TopModule (
    input clk,
    input aresetn,
    input x,
    output logic z
);

    typedef enum logic [1:0] {
        S0 = 2'd0, // No progress
        S1 = 2'd1, // Saw '1'
        S2 = 2'd2  // Saw '10'
    } state_t;

    state_t state, next_state;

    // Sequential logic for state transition
    always_ff @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= S0;
        end else begin
            state <= next_state;
        end
    end

    // Combinational logic for next state and output
    always_comb begin
        next_state = state;
        z = 1'b0;

        case (state)
            S0: begin
                if (x) next_state = S1;
                else   next_state = S0;
            end
            S1: begin
                if (x) next_state = S1;
                else   next_state = S2;
            end
            S2: begin
                if (x) begin
                    next_state = S1;
                    z = 1'b1; // Sequence 101 detected
                end else begin
                    next_state = S0;
                end
            end
            default: next_state = S0;
        endcase
    end

endmodule
