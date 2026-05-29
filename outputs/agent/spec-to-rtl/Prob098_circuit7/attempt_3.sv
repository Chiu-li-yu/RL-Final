module TopModule (
    input clk,
    input a,
    output logic q
);

    logic a_inv_reg;

    always @(posedge clk) begin
        a_inv_reg <= ~a;
        q <= a_inv_reg;
    end

endmodule
