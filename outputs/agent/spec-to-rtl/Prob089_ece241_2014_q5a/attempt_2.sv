module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    logic state, next_state;

    // Moore machine:
    // S0: No 1 seen yet.
    // S1: 1 seen.
    // At S0, output is x.
    // At S1, output is !x.
    // Wait, 2's complement logic: 
    // If input is 0...0100 (LSB first), 2's complement is 1...1100.
    // Pattern: 
    // Input:  0 0 1 0 0 ...
    // Output: 0 0 1 1 1 ...
    // State S0: 0 -> z=0, next=S0; 1 -> z=1, next=S1
    // State S1: 0 -> z=1, next=S1; 1 -> z=0, next=S1

    localparam S0 = 1'b0;
    localparam S1 = 1'b1;

    always @(*) begin
        case (state)
            S0: next_state = x ? S1 : S0;
            S1: next_state = S1;
            default: next_state = S0;
        endcase
    end

    // Moore output logic
    assign z = (state == S0) ? x : ~x;

    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= S0;
        else
            state <= next_state;
    end

endmodule
