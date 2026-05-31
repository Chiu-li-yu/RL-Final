module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);
    logic [31:0] prev_in;
    logic [31:0] captured;

    assign out = captured;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_in <= in;
            captured <= 32'b0;
        end else begin
            prev_in <= in;
            captured <= captured | (prev_in & ~in);
        end
    end
endmodule
