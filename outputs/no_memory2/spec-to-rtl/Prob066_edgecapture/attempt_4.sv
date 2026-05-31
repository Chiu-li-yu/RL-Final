module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output logic [31:0] out
);

    logic [31:0] prev_in;
    logic [31:0] transition;

    // Detect 1 to 0 transition
    always @(*) begin
        transition = prev_in & (~in);
    end

    always @(posedge clk) begin
        if (reset) begin
            out <= 32'b0;
            prev_in <= 32'b0;
        end else begin
            prev_in <= in;
            out <= out | transition;
        end
    end

endmodule