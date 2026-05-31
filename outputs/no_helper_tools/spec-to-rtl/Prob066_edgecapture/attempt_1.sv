module TopModule (
    input logic clk,
    input logic reset,
    input logic [31:0] in,
    output logic [31:0] out
);

    logic [31:0] prev_in;
    logic [31:0] captured;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end else begin
            prev_in <= in;
            captured <= captured | (prev_in & ~in);
        end
    end

    always_comb begin
        out = captured;
    end

endmodule
