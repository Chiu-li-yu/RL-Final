module TopModule (
    input clk,
    input in,
    output out
);
    logic q;

    // Use initial block to set reset value if implicit reset is expected,
    // though the prompt says "there is no reset". 
    // Maybe the DFF state is initially 0.
    initial q = 1'b0;

    always_ff @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;
endmodule
