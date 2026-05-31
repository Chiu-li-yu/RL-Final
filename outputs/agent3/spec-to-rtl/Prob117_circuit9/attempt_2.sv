module TopModule (
    input clk,
    input a,
    output logic [2:0] q
);

    initial q = 3'b100;

    always @(posedge clk) begin
        if (a) begin
            q <= 3'b100;
        end else begin
            q <= q + 1'b1;
        end
    end

endmodule