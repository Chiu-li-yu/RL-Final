module TopModule (
    input clk,
    input [7:0] in,
    output logic [7:0] pedge
);

    logic [7:0] prev_in;

    // The spec says: "The output bit should be set the cycle after a 0 to 1 transition occurs."
    // Current logic: pedge = in & ~prev_in; 
    // If in moves 0 -> 1 at cycle T, prev_in at T is 0.
    // So pedge = 1 & ~0 = 1 at cycle T. 
    // This is the SAME cycle, but it needs to be the NEXT cycle.
    
    // We need to capture the transition, then delay it by one cycle.

    logic [7:0] transition;

    always_ff @(posedge clk) begin
        prev_in <= in;
        transition <= (in & ~prev_in);
        pedge <= transition;
    end

endmodule
