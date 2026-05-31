module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output logic [31:0] out
);

    logic [31:0] prev_in;

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
            // Capture 1 to 0 transition: prev_in[i] == 1 && in[i] == 0
            // OR the existing out status
            out <= out | (prev_in & ~in);
        end
    end

endmodule
