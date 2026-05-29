module TopModule(
    input clk,
    input in,
    output logic out
);

    logic q;

    // D flip-flop takes as input the output of a two-input XOR
    // XOR takes as input 'in' along with the output 'out' of the flip-flop
    // The flip-flop has no reset.
    // Assuming out starts at 0 initially as is standard for unspecified logic,
    // let's verify if the test expects a specific initialization.

    always_ff @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;

endmodule
