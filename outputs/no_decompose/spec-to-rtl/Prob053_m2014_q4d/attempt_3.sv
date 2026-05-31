module TopModule (
    input logic clk,
    input logic in,
    output logic out
);

    logic q;

    // D flip-flop state update
    always_ff @(posedge clk) begin
        q <= in ^ q;
    end

    // The output is the value of the D flip-flop (q)
    assign out = q;

    // Initial condition: Assuming flip-flop starts at 0
    initial begin
        q = 1'b0;
    end

endmodule
