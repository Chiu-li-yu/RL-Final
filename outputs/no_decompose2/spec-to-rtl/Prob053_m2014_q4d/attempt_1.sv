module TopModule (
    input clk,
    input in,
    output out
);
    logic dff_q;

    // DFF: output out is the state of the flip-flop
    // The input to the flip-flop is (in XOR out)
    always_ff @(posedge clk) begin
        dff_q <= in ^ dff_q;
    end

    assign out = dff_q;
endmodule
