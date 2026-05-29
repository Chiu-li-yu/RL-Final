module TopModule (
    input clk,
    input [7:0] in,
    output logic [7:0] anyedge
);
    logic [7:0] in_prev;

    always @(posedge clk) begin
        in_prev <= in;
        anyedge <= in ^ in_prev;
    end

endmodule
