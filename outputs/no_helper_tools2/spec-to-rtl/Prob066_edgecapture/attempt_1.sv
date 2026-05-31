module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    logic [31:0] prev_in;
    logic [31:0] captured;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured <= 32'b0;
        end else begin
            prev_in <= in;
            // Capture if change from 1 (prev) to 0 (curr)
            captured <= captured | (prev_in & ~in);
        end
    end

    assign out = captured;

endmodule