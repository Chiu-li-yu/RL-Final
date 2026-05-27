module TopModule (
    input clk,
    input reset,
    input [31:0] in,
    output [31:0] out
);

    logic [31:0] prev_in;
    logic [31:0] out_reg;

    assign out = out_reg;

    always_ff @(posedge clk) begin
        if (reset) begin
            prev_in <= 32'b0;
            out_reg <= 32'b0;
        end else begin
            prev_in <= in;
            // Capture: when bit changes from 1 to 0 (prev=1, current=0)
            // out stays 1 once triggered.
            out_reg <= out_reg | (prev_in & ~in);
        end
    end

endmodule
