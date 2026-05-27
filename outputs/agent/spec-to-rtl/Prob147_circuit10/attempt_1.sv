module TopModule (
    input clk,
    input a,
    input b,
    output logic q,
    output logic state
);

    logic next_state;

    // Sequential logic: Flip-flop
    always @(posedge clk) begin
        state <= next_state;
    end

    // Combinational logic: Determine next_state and q
    always @(*) begin
        // q = a ^ b ^ state
        q = a ^ b ^ state;
        
        // next_state: Derived from observing transitions
        // Based on analysis:
        // when a=1, b=1, next_state = ~state
        // when !(a=1 && b=1), next_state = state
        if (a && b) begin
            next_state = ~state;
        end else begin
            next_state = state;
        end
    end

endmodule
