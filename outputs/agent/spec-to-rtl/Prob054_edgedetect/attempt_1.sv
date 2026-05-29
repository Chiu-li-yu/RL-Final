module TopModule (
    input clk,
    input [7:0] in,
    output logic [7:0] pedge
);

    logic [7:0] in_prev;

    always @(posedge clk) begin
        in_prev <= in;
        pedge <= in & ~in_prev;
    end

endmodule
