module TopModule (
    input clk,
    input a,
    output logic [2:0] q
);

    always @(posedge clk) begin
        if (a) begin
            q <= 3'd4;
        end else begin
            q <= q + 1'b1;
        end
    end

endmodule
