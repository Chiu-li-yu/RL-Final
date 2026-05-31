module TopModule (
    input clk,
    input reset,
    output logic [3:0] q
);

    always_ff @(posedge clk) begin
        if (reset) begin
            q <= 4'b0000;
        end else begin
            if (q == 4'd9) begin
                q <= 4'b0000;
            end else begin
                q <= q + 1'b1;
            end
        end
    end

endmodule
