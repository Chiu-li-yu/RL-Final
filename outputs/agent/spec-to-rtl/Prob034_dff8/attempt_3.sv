module TopModule (
    input logic clk,
    input logic [7:0] d,
    output logic [7:0] q
);
    logic [7:0] q_reg;
    assign q = q_reg;

    always_ff @(posedge clk) begin
        q_reg <= d;
    end
endmodule
