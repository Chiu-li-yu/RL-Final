module TopModule (
    input clk,
    input in,
    output out
);
    logic q;

    // D flip-flop takes as input the output of a two-input XOR
    // XOR takes as input 'in' along with the output 'out' (which is q)
    always_ff @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;
endmodule
