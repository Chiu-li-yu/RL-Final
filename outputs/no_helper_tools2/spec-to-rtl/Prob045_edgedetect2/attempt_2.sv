module TopModule(
    input clk,
    input [7:0] in,
    output logic [7:0] anyedge
);
    logic [7:0] in_d;

    always @(posedge clk) begin
        in_d <= in;
    end

    always @(*) begin
        anyedge = in ^ in_d;
    end

endmodule