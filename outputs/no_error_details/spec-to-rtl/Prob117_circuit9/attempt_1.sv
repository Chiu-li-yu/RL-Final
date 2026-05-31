module TopModule (
    input clk,
    input a,
    output logic [2:0] q
);
    always_ff @(posedge clk) begin
        if (a) begin
            q <= 3'd4;
        end else begin
            if (q >= 3'd4 && q < 3'd6) begin
                q <= q + 3'd1;
            end else begin
                q <= 3'd0;
            end
        end
    end
endmodule