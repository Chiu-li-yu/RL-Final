module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output logic [31:0] out
);

    logic [31:0] in_prev;

    always @(posedge clk) begin
        in_prev <= in;
        if (reset) begin
            out <= 32'b0;
        end else begin
            // Falling edge detection: (previous was 1) AND (current is 0)
            // Use bitwise OR to keep the "sticky" property
            out <= out | (in_prev & ~in);
        end
    end

endmodule
