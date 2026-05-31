module TopModule (
    input logic clk,
    input logic x,
    output logic z
);
    logic q_xor, q_and, q_or;
    logic d_xor, d_and, d_or;

    // FSM behavior defined by gates:
    // 1. XOR gate: input is (x ^ q_xor), output is d_xor
    // 2. AND gate: input is (x & ~q_and), output is d_and
    // 3. OR gate: input is (x | ~q_or), output is d_or
    // Z is the NOR of the three flip-flop outputs.

    always @(*) begin
        d_xor = x ^ q_xor;
        d_and = x & (~q_and);
        d_or  = x | (~q_or);
        z     = ~(q_xor | q_and | q_or);
    end

    always_ff @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

endmodule
