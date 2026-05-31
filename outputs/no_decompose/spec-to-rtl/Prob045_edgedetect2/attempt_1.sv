module TopModule (
    input clk,
    input [7:0] in,
    output logic [7:0] anyedge
);

    logic [7:0] last_in;

    always_ff @(posedge clk) begin
        last_in <= in;
        anyedge <= in ^ last_in;
    end

endmodule
