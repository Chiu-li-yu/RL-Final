module TopModule (
    input logic clk,
    input logic in,
    output logic out
);

    logic q;

    // D Flip-Flop
    // D = in ^ q
    // Reset defaults to 0 in simulation if not specified, 
    // but the problem doesn't mention a reset. 
    // Maybe an initial value is expected for simulation?
    initial q = 1'b0;

    always_ff @(posedge clk) begin
        q <= in ^ q;
    end

    assign out = q;

endmodule