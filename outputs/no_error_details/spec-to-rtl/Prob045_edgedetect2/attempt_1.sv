module TopModule (
    input clk,
    input [7:0] in,
    output [7:0] anyedge
);

    logic [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;
    end

    always @(*) begin
        // The output anyedge should be set to 1 the cycle after the transition occurs.
        // If prev_in != in, there was a transition at the previous cycle.
        // Since the current cycle is the "cycle after" the transition happened,
        // we use prev_in and the registered state from the cycle before.
        // Wait, the specification says:
        // "The output bit of anyedge should be set to 1 the cycle after 
        // the input bit has 0 to 1 or 1 to 0 transition occurs."
        // If clk1: input = A, clk2: input = B.
        // At clk2, we compare B with A. If B != A, at clk2, output should be 1.
        anyedge = prev_in ^ in;
    end

endmodule
