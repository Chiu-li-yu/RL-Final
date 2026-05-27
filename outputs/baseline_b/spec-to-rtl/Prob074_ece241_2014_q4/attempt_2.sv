module TopModule (
    input logic clk,
    input logic x,
    output logic z
);

    // Three D flip-flops: state bits
    logic q1, q2, q3;
    
    // Internal signals for next states
    logic d1, d2, d3;

    // XOR gate: output = x ^ q1
    // Input of D flip-flop 1 is XOR output
    assign d1 = x ^ q1;

    // AND gate: output = x & (~q2)
    // Input of D flip-flop 2 is AND output
    assign d2 = x & (~q2);

    // OR gate: output = x | (~q3)
    // Input of D flip-flop 3 is OR output
    assign d3 = x | (~q3);

    // Sequential logic triggered on positive edge of clock
    always_ff @(posedge clk) begin
        q1 <= d1;
        q2 <= d2;
        q3 <= d3;
    end

    // The three flip-flop outputs go to a three-input NOR gate
    // Output z = ~(q1 | q2 | q3)
    assign z = ~(q1 | q2 | q3);

endmodule
