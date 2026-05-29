module TopModule (
    input clk,
    input a,
    output logic q
);

    logic a_reg;

    always @(posedge clk) begin
        a_reg <= a;
        q <= ~a_reg;
    end

endmodule
