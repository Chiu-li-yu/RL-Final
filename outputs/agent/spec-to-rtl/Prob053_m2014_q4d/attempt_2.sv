module TopModule(
    input clk,
    input in,
    output logic out
);

    logic d_ff_q;

    // A D flip-flop takes as input the output of a two-input XOR.
    // The XOR takes as input 'in' along with the output 'out' of the flip-flop.
    // D = in ^ out

    always_ff @(posedge clk) begin
        d_ff_q <= in ^ d_ff_q;
    end

    assign out = d_ff_q;

endmodule
