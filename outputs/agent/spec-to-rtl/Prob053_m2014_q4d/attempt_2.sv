module TopModule (
    input logic clk,
    input logic in,
    output logic out
);

    logic q;

    // D Flip-Flop
    // D = in ^ q
    always_ff @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;

endmodule