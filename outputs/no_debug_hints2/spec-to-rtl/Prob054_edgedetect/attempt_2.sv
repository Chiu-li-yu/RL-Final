module TopModule(
    input clk,
    input [7:0] in,
    output logic [7:0] pedge
);
    logic [7:0] prev_in;

    always @(posedge clk) begin
        prev_in <= in;
    end

    always @(*) begin
        pedge = (in & ~prev_in);
    end

endmodule
