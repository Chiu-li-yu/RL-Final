module TopModule (
    input clk,
    input [7:0] in,
    output logic [7:0] anyedge
);
    logic [7:0] prev_in;

    always @(posedge clk) begin
        anyedge <= in ^ prev_in;
        prev_in <= in;
    end
endmodule
