module TopModule (
    input logic clk,
    input logic in,
    output logic out
);

    logic d;
    logic q;

    // XOR gate: d = in XOR q
    always @(*) begin
        d = in ^ q;
    end

    // D Flip-Flop
    always_ff @(posedge clk) begin
        q <= d;
    end

    assign out = q;

endmodule