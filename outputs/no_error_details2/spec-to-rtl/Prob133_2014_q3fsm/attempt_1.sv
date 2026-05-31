module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // States: 
    // A: Initial state, waiting for s=1
    // B: Processing (3-cycle loop)
    // S_CHECK1: First cycle
    // S_CHECK2: Second cycle
    // S_CHECK3: Third cycle (evaluating result)

    typedef enum logic [2:0] {
        S_A = 3'b000,
        S_B1 = 3'b001,
        S_B2 = 3'b010,
        S_B3 = 3'b011
    } state_t;

    logic [2:0] state, next_state;
    logic [1:0] count_ones; // Count how many times w=1
    logic next_z;

    always_ff @(posedge clk) begin
        if (reset) begin
            state <= S_A;
            count_ones <= 2'b00;
        end else begin
            state <= next_state;
            if (state == S_A) count_ones <= 2'b00;
            else if (state == S_B1) count_ones <= (w ? 2'b01 : 2'b00);
            else if (state == S_B2) count_ones <= count_ones + (w ? 2'b01 : 2'b00);
            else if (state == S_B3) count_ones <= 2'b00; // Reset after evaluation
        end
    end

    always @(*) begin
        next_state = state;
        next_z = 1'b0;

        case (state)
            S_A: begin
                if (s) next_state = S_B1;
            end
            S_B1: begin
                next_state = S_B2;
            end
            S_B2: begin
                next_state = S_B3;
            end
            S_B3: begin
                // Evaluation happens here, z should be set for the *following* cycle
                // Actually the prompt says: "in the following clock cycle"
                // My logic sets z based on current state S_B3. 
                // Wait, if it's "in the following clock cycle", I should hold it.
                // Re-reading: "If w=1 in exactly two of these clock cycles, 
                // then the FSM has to set an output z to 1 in the following clock cycle."
                // This implies z is high during the transition from S_B3 to S_B1.
                next_state = S_B1;
                if (count_ones + (w ? 1 : 0) == 2'd2) next_z = 1'b1;
                else next_z = 1'b0;
            end
        endcase
    end

    assign z = next_z;

endmodule
