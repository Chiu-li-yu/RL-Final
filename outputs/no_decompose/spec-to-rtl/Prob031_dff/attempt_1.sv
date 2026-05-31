module TopModule (
    input clk,
    input d,
    output logic q
);

    always @(posedge clk) begin
        q <= d;
    end

endmodule