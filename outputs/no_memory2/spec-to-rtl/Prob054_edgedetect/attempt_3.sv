module TopModule (
    input logic clk,
    input logic [7:0] in,
    output logic [7:0] pedge
);
    logic [7:0] in_d;

    always_ff @(posedge clk) begin
        in_d <= in;
    end

    always_comb begin
        pedge = (in & ~in_d);
    end
endmodule