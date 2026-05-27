module TopModule (
    input logic clk,
    input logic a,
    output logic [2:0] q
);

    always_ff @(posedge clk) begin
        if (a) begin
            q <= 3'd4;
        end else begin
            q <= q + 3'd1;
        end
    end

endmodule
