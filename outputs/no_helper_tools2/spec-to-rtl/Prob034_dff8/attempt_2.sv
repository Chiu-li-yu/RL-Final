module TopModule (
    input clk,
    input [7:0] d,
    output logic [7:0] q
);
    initial q = 8'b0;

    always @(posedge clk) begin
        q <= d;
    end
endmodule
