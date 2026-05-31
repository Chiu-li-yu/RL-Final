module TopModule (
    input clk,
    input a,
    output logic q
);

    logic q_reg;
    assign q = q_reg;

    always @(posedge clk) begin
        if (a == 1'b0) begin
            q_reg <= 1'b1;
        end else begin
            q_reg <= 1'b0;
        end
    end

endmodule