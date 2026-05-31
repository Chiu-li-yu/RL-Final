module TopModule (
    input  logic clk,
    input  logic [7:0] d,
    output logic [7:0] q
);

    initial q = 8'b0;

    always_ff @(posedge clk) begin
        q <= d;
    end

endmodule
