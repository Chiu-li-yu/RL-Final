module TopModule (
    input clk,
    input x,
    output z
);
    logic q_xor, q_and, q_or;
    logic d_xor, d_and, d_or;

    // Flip-flop updates with reset
    initial begin
        q_xor = 0;
        q_and = 0;
        q_or  = 0;
    end
    
    always_ff @(posedge clk) begin
        q_xor <= d_xor;
        q_and <= d_and;
        q_or  <= d_or;
    end

    // Combinational logic for D inputs
    // "The second input of the XOR is its corresponding flip-flop's output"
    // "The second input of the AND is its corresponding flip-flop's complemented output"
    // "The OR is its corresponding flip-flop's complementary output"
    always @(*) begin
        d_xor = x ^ q_xor;
        d_and = x & ~q_and;
        d_or  = x | ~q_or;
    end

    // NOR gate output
    assign z = ~(q_xor | q_and | q_or);

endmodule
