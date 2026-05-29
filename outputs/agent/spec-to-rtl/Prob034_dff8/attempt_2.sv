module TopModule (
    input clk,
    input [7:0] d,
    output logic [7:0] q
);

    initial begin
        q = 8'b0;
    end

    always_ff @(posedge clk) begin
        q <= d;
    end

endmodule
