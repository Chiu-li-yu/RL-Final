module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    logic [31:0] prev_in;
    logic [31:0] captured_out;

    assign out = captured_out;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            captured_out <= 32'b0;
        end else begin
            // Detect 1 to 0 transition
            // current cycle (in), previous cycle (prev_in)
            // Transition: prev_in == 1 AND in == 0
            captured_out <= captured_out | (prev_in & ~in);
            prev_in <= in;
        end
    end

endmodule