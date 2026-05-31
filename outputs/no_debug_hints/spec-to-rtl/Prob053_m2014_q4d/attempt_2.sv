module TopModule(
    input clk,
    input in,
    output out
);
    logic q;

    // D flip-flop, the state is 'q', output is 'out'
    // The XOR takes 'in' and 'out' (which is the output of the flip-flop)
    // d = in ^ out
    always @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;
endmodule