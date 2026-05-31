module TopModule(
    input clk,
    input in,
    output out
);
    logic d;
    logic q;

    // XOR gate: output of D flip-flop (q) XORed with input (in)
    always @(*) begin
        d = in ^ q;
    end

    // D flip-flop
    always @(posedge clk) begin
        q <= d;
    end

    assign out = q;
endmodule