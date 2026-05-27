module TopModule (
    input logic clk,
    input logic in,
    output logic out
);

    logic d_ff_q;

    // The XOR takes as input 'in' along with the output 'out' of the flip-flop.
    // D flip-flop takes as input the output of the XOR.
    // Since 'out' is the output of the flip-flop, we connect it directly.

    always_ff @(posedge clk) begin
        d_ff_q <= in ^ d_ff_q;
    end

    assign out = d_ff_q;

endmodule
