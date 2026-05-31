module TopModule (
    input clk,
    input in,
    output out
);

    logic q;
    
    // The flip-flop is positive edge triggered by clk, no reset.
    // The XOR takes as input 'in' along with the output 'out' (which is q).
    // D = in ^ out (current state q)
    
    always @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;

endmodule
